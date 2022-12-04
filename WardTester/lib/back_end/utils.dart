import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import 'package:trying/back_end/non_math_parser.dart';
import 'math_function.dart';
import 'dart:convert';
import 'math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'Test.dart';
import 'Question.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

Future<LinkedHashMap<String, dynamic>> readFile(String question_file) async {
  final String response = await rootBundle.loadString(question_file);
  return json.decode(response);
}

Question getNextQuestion(var data, int cur) {
  var currentQuestion = data.keys.elementAt(cur);
  var type = data[currentQuestion]["QuestionType"];
  var topic = data[currentQuestion]["Topic"];
  var imagePath = "";
  if (data[currentQuestion]["ImagePath"] != null) {
    imagePath = data[currentQuestion]["ImagePath"];
  }

  if (type == 0) {
    // MC Question
    var question = data[currentQuestion]["Question"];
    var answer = data[currentQuestion]["Answer"];
    var choice = data[currentQuestion]["Choices"];

    print("MC Answer: $answer");
    return new Question0(question, type, answer, choice, topic, imagePath);
  } else if (type == 1) {
    // FR Question
    var question = data[currentQuestion]["Question"];
    var answer = data[currentQuestion]["Answers"];

    print("FR Answer: $answer");
    return new Question1(question, type, answer, topic, imagePath);
  } else {
    // Random Free Response Question
    var questionRaw = data[currentQuestion]["Question"];
    var variables = data[currentQuestion]["Variables"];
    var equations = data[currentQuestion]["Equations"];
    var answerRaw = data[currentQuestion]["Answers"][0];

    var question = '';
    var varSave = new Map();
    //  for the different value for different equations
    List<String> answerList = [];

    // Stage 0: Get random values for variables
    for (int i = 0; i < variables.length; i++) {
      double current = generateRandom(
          variables[i]["LowerBound"].toDouble(),
          variables[i]["UpperBound"].toDouble(),
          variables[i]["Step"].toDouble());
      if (variables[i]["Step"].toDouble() ==
          variables[i]["Step"].toDouble().roundToDouble()) {
        varSave[variables[i]["VarName"]] = floor(current).toInt();
      } else {
        varSave[variables[i]["VarName"]] = double.parse(current
            .toStringAsFixed(
                logBase(variables[i]["Step"].toDouble(), 0.1).toInt())
            .toString());
      }
    }

    // Stage 1: Put values into question
    question = questionRaw;
    while (question.contains("~")) {
      for (int i = 0; i < varSave.length; i++) {
        var curVariable = varSave.keys.elementAt(i);
        while (question.contains("~$curVariable")) {
          question = question.replaceAll(
              "~$curVariable", varSave[curVariable].toString());
        }
      }
    }

    int i = 0;
    for (i = 0; i < equations.length; i++) {
      //Stage 2: Start to replace variable with their corresponding values
      String currentEquation = equations[i];
      while (currentEquation.contains("~")) {
        for (int i = 0; i < varSave.length; i++) {
          var curVariable = varSave.keys.elementAt(i);
          while (currentEquation.contains("~$curVariable")) {
            currentEquation = currentEquation.replaceAll(
                "~$curVariable", varSave[curVariable].toString());
          }
        }
      }

      //Stage 3: Evaluate the equation
      if (currentEquation.length > 2) {
        if (currentEquation.substring(0, 2) == "!!") {
          String res = nonMathParser(currentEquation).toString();
          answerList.add(res);
        } else {
          ContextModel cm = ContextModel();
          print(currentEquation);
          Expression exp = p.parse(currentEquation);

          double res = exp.evaluate(EvaluationType.REAL, cm);

          if (res == res.roundToDouble()) {
            answerList.add(res.toInt().toString());
          } else {
            answerList.add(res.toStringAsFixed(3));
          }
        }
      } else {
        ContextModel cm = ContextModel();
        print(currentEquation);
        Expression exp = p.parse(currentEquation);

        double res = exp.evaluate(EvaluationType.REAL, cm);

        if (res == res.roundToDouble()) {
          answerList.add(res.toInt().toString());
        } else {
          answerList.add(res.toStringAsFixed(3));
        }
      }
    }

    var correctAnswer = answerRaw;
    for (int i = 0; i < answerList.length; i++) {
      correctAnswer = correctAnswer.replaceFirst("~^~", answerList[i]);
    }

    print("FRQ Answer: $correctAnswer");
    return new Question2(question, type, equations, answerRaw, correctAnswer,
        answerList, varSave, topic, imagePath);
  }
}

void submitPressed(bool isCorrect) {
  if (isCorrect) {
    resultDisplay = "This is correct!";
    questionOrder.removeFirst();
    currentTest.incrementAttempt();
  } else {
    resultDisplay = "The correct answer is: ${currentQ.getAnswerString()}";
    questionOrder.add(questionOrder.first);
    questionOrder.removeFirst();
    currentTest.incrementAttempt();
  }
  submitButtonText = "Next";
  hasSubmitted = !hasSubmitted;
}

bool nextPressedIsMoreQuestions() {
  cur = cur + 1;
  resultDisplay = "";
  submitButtonText = "Submit";
  hasSubmitted = !hasSubmitted;

  if (questionOrder.isNotEmpty) {
    currentQ = getNextQuestion(test_file, questionOrder.first);

    //add the imagepath for next question display
    if (currentQ.getImagePath() != "") {
      currentQ.setImagePath("$appDocPath/Image/" + currentQ.getImagePath());
    }

    //save the progress
    currentTest.setQuestionOrder(questionOrder);
    saveProgress(currentTest, testList).then((List<Test> value) {
      testList = value;
    });

    return true;
  } else {
    // set the end time for the test + save progress
    currentTest.setTimeEnd(DateTime.now());
    currentTest.setQuestionOrder(questionOrder);

    saveCompleteTest(currentTest, completeTestList).then((List<Test> value) {
      completeTestList = value;
    });

    removeProgress(currentTest, testList).then((List<Test> value) {
      testList = value;
    });

    //Reset the index of current quesion for the next test
    cur = 0;
    return false;
  }
}

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

Future<List> downloadQuestion() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'Jkk0zBewPQACbqAYHeL2C4rVFSvj1WXlTQtPRaQD';
  final keyClientKey = '9iTzK49uR12cJHM9qn3fiFsnVEYBqseYjZC18tqw';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  QueryBuilder<ParseObject> queryFile =
      QueryBuilder<ParseObject>(ParseObject('JSON'));
  final ParseResponse apiResponse = await queryFile.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

// Getting device type: return phone and tablet
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}

//downloadFile and store it in a correct directories using Dio
Future<File?> downloadFileImage(String url, String name) async {
  final file = File('$appDocPath/Image/$name');

  final response = await Dio().get(url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ));

  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();

  return file;
}

/// Save the progress to the current file
Future<List<Test>> saveProgress(var currentTest, var currentTestList) async {
  //initialize file path
  final progressFile = File('$appDocPath/progress.txt');

  //add the new test progress into the current testList
  currentTestList.add(currentTest);

  //remove the second test with the same name
  //TODO: think of a better efficient way
  var seen = Set<String>();
  List<dynamic> uniqueTest =
      currentTestList.where((test) => seen.add(test.getName())).toList();
  List<Test> list = uniqueTest.cast<Test>();

  //log down the progress file
  progressFile.writeAsStringSync(jsonEncode(uniqueTest));

  return list;
}

///This function is used when a test is completed and needed to be remove from current test.
Future<List<Test>> removeProgress(var currentTest, var currentTestList) async {
  //initialize file path
  final progressFile = File('$appDocPath/progress.txt');
  currentTestList
      .removeWhere((element) => element.getName() == currentTest.getName());
  progressFile.writeAsStringSync(jsonEncode(currentTestList));

  return currentTestList;
}

Future<List<Test>> saveCompleteTest(
    var completeTest, var completeTestList) async {
  //initialize file path
  final completeFile = File('$appDocPath/complete.txt');

  //add the new test progress into the current testList
  completeTestList.add(completeTest);
  completeFile.writeAsStringSync(jsonEncode(completeTestList));

  return completeTestList;
}

Future<bool> checkFirstTime() async {
  final progressFile = File('$appDocPath/progress.txt');

  if (progressFile.existsSync()) {
    return false;
  } else {
    return true;
  }
}

//read the progress from the file and update the test
Future<List<Test>> readProgress() async {
  final progressFile = File('$appDocPath/progress.txt');

  String progressString = progressFile.readAsStringSync();

  if (progressString.isNotEmpty) {
    //turn data into a list of test (record of test progress)
    var testObjsJson = jsonDecode(progressString) as List;
    List<Test> testList =
        testObjsJson.map((testJson) => Test.fromJson(testJson)).toList();
    return testList;
  }

  return [];
}

//read the progress from the file and update the test
Future<List<Test>> loadCompleteTest() async {
  final completeRecordFile = File('$appDocPath/complete.txt');

  String completeString = completeRecordFile.readAsStringSync();

  if (completeString.isNotEmpty) {
    //turn data into a list of test (record of test progress)
    var testObjsJson = jsonDecode(completeString) as List;
    List<Test> testList =
        testObjsJson.map((testJson) => Test.fromJson(testJson)).toList();
    return testList;
  }

  return [];
}

// return course name and current list name
Future<Set<String>> updateTestFile() async {
  //setting up application directory
  final courseFile = File('$appDocPath/course.txt');
  print("Path for this device: " + appDocPath); // printing our the directory

  //setting up back4app ID address
  final keyApplicationId = 'Jkk0zBewPQACbqAYHeL2C4rVFSvj1WXlTQtPRaQD';
  final keyClientKey = '9iTzK49uR12cJHM9qn3fiFsnVEYBqseYjZC18tqw';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  //setting up JSON File for VERSION JSON file through Back4App Connection
  QueryBuilder<ParseObject> version =
      QueryBuilder<ParseObject>(ParseObject('JSON_Version'));
  version.whereEqualTo("dataType", "jsonFile");
  final ParseResponse versionResponse = await version.query();
  List<ParseObject> versionList = versionResponse.results as List<ParseObject>;

  //setting up JSON File for question file through Back4App Connection
  QueryBuilder<ParseObject> jsonQuestionParse =
      QueryBuilder<ParseObject>(ParseObject("JSON"));
  final ParseResponse jsonResponse = await jsonQuestionParse.query();

  //check if there is an existing version file to download the questionFile or not
  final versionFile = File('$appDocPath/version.txt');

  if ((versionFile.existsSync() &&
          versionFile.readAsStringSync() !=
              versionList[versionList.length - 1]["date"]) ||
      !versionFile.existsSync()) {
    print("version is different!");
    Queue courseList1 = new Queue<String>();

    //looping over all of the items to find the names for the course and potentially units
    for (var o in jsonResponse.results as List<ParseObject>) {
      String? currentCourse = o.get<String>('Course');
      if (!courseList1.contains(currentCourse)) {
        courseList1.add(currentCourse);
      }
    }

    //courseList2 is a duplicate of courseList1, in order to loop over and adjust
    //the unit file.
    Queue courseList2 = new Queue.from(courseList1);
    courseFile.writeAsStringSync(courseList1
        .toString()
        .substring(1, courseList1.toString().indexOf('}')));

    //looping through course and add units into the corresponding directories
    while (courseList2.isNotEmpty) {
      jsonQuestionParse
        ..whereArrayContainsAll('Course', [courseList2.first])
        ..orderByAscending("Unit");
      var unitResponse = await jsonQuestionParse.query();
      Queue unitList1 = new Queue<String>();

      if (unitResponse.success && unitResponse.results != null) {
        for (var object in unitResponse.results as List<ParseObject>) {
          unitList1.add(object.get<String>("Unit"));
        }
        String unitListFile = "";
        int unitListLength = unitList1.length;

        for (int i = 0; i < unitListLength - 1; i++) {
          unitListFile = unitListFile +
              unitList1.first.substring(0, unitList1.first.indexOf('.')) +
              ",";
          unitList1.removeFirst();
        }
        unitListFile = unitListFile +
            unitList1.first.substring(0, unitList1.first.indexOf('.'));

        //String to pass in for the file is stored in unitList File
        await Directory('$appDocPath/' + courseList2.first)
            .create(recursive: true);
        var unitFile = File('$appDocPath/' + courseList2.first + "/unit.txt");
        unitFile.writeAsStringSync(unitListFile);

        courseList2.removeFirst();
      }
    }

    //downloading file to the correct directories
    jsonQuestionParse = QueryBuilder<ParseObject>(ParseObject("JSON"));
    final fileResponse = await jsonQuestionParse.query();

    for (var o in fileResponse.results as List<ParseObject>) {
      var url = Uri.parse(o["QuestionFile"]["url"]);
      print(url);
      var json_response = await http.get(url);
      var data = jsonDecode(json_response.body);
      var file = File('$appDocPath/' +
          o.get<String>("Course")! +
          '/' +
          o
              .get<String>("Unit")!
              .substring(0, o.get<String>("Unit")!.indexOf('.')) +
          '.txt');
      file.writeAsStringSync(jsonEncode(data));
    }

    //update the version in the file
    versionFile.writeAsString(versionList[versionList.length - 1]["date"]);
  }

  String courseListContent = await courseFile.readAsString();
  List<String> courseListNew = courseListContent.split(", ");
  var courseSet = courseListNew.toSet();

  loadImageFile();
  return courseSet;
}

/// Function called in the main file when first start the program
/// Check if there is student name yet
Future<String> loadNameFile() async {
  final nameFile = File("$appDocPath/name.txt");
  if (nameFile.existsSync()) {
    return nameFile.readAsStringSync();
  }
  return "";
}

/// Funtion called in the main file when first start the program
/// Check for new version of Image File and and nver worked for the new wokring places
void loadImageFile() async {
  //setting up application directory
  print("Path for this device: " + appDocPath); // printing our the directory

  //setting up back4app ID address
  final keyApplicationId = 'Jkk0zBewPQACbqAYHeL2C4rVFSvj1WXlTQtPRaQD';
  final keyClientKey = '9iTzK49uR12cJHM9qn3fiFsnVEYBqseYjZC18tqw';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  //setting up JSON File for VERSION JSON file through Back4App Connection
  QueryBuilder<ParseObject> version =
      QueryBuilder<ParseObject>(ParseObject('JSON_Version'));
  version.whereEqualTo("dataType", "jsonFile");

  version.whereEqualTo("dataType", "imageFile");
  final ParseResponse imageVersionResponse = await version.query();
  List<ParseObject> imageVersionList =
      imageVersionResponse.results as List<ParseObject>;
  final imageVersionFile = File('$appDocPath/imageVersion.txt');
  if ((imageVersionFile.existsSync() &&
          imageVersionFile.readAsStringSync() !=
              imageVersionList[imageVersionList.length - 1]["date"]) ||
      !imageVersionFile.existsSync()) {
    // add an image directory:
    await Directory('$appDocPath/Image').create(recursive: true);

    //setting up Image File for question file through Back4App Connection
    QueryBuilder<ParseObject> imageParse =
        QueryBuilder<ParseObject>(ParseObject("Images"));
    final ParseResponse imageResponse = await imageParse.query();

    for (var o in imageResponse.results as List<ParseObject>) {
      ParseFileBase? currentImageFile = o.get<ParseFileBase>('ImageFile');
      if (currentImageFile == null) continue;
      String? currentImageName = o.get<String>("FileName");
      String? imageURL = currentImageFile["url"];

      downloadFileImage(imageURL!, currentImageName!);
    }

    // update the date in image version file
    imageVersionFile
        .writeAsString(imageVersionList[imageVersionList.length - 1]["date"]);
  }
}

/// Import all Mathematics Parser by calling all of them.
void importMathParser() {
  normalCDF_parser();
  binomialCDF_parser();
  inverseNormalCDF_parser();
  permutation_parser();
  combination_parser();
  binomialPDF_parser();
  geometPDF_parser();
  geometCDF_parser();
  chiSquaredCDF_parser();
  tDistCDF_parser();
  inverseTCDF_parser();
  median_parser();
  stddev_parser();
  average_parser();
  min_parser();
  max_parser();
  //floor_parser();
  //ceil_parser();
  gcf_parser();
  lcm_parser();
  //abs_parser();
  sum_parser();
  //count_parser();
  nthroot_parser();
  pi_parser();
  //e_parser();
  power_parser();
}
