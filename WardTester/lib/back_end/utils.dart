import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trying/back_end/non_math_parser.dart';
import 'math_function.dart';
import 'dart:convert';
import 'math.dart';
import 'math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'Test.dart';
import 'Question.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'Test.dart';
import 'package:http/http.dart' as http;

Future<LinkedHashMap<String, dynamic>> readFile(String question_file) async {
  final String response = await rootBundle.loadString(question_file);
  return json.decode(response);
}

Question getQuestionInfo(var data, int cur) {
  var currentQuestion = data.keys.elementAt(cur);
  var type = data[currentQuestion]["QuestionType"];
  var topic = data[currentQuestion]["Topic"];
  var imagePath = "";
  if (data[currentQuestion]["ImagePath"] != null) {
    imagePath = data[currentQuestion]["ImagePath"];
  }

  if (type == 0) {
    var question = data[currentQuestion]["Question"];
    var answer = data[currentQuestion]["Answer"];
    var choice = data[currentQuestion]["Choices"];

    return new Question0(question, type, answer, choice, topic, imagePath);
  } else if (type == 1) {
    var question = data[currentQuestion]["Question"];
    var answer = data[currentQuestion]["Answers"];

    return new Question1(question, type, answer, topic, imagePath);
    // Customized Free Response Question
  } else {
    var questionRaw = data[currentQuestion]["Question"];
    var variables = data[currentQuestion]["Variables"];
    var equations = data[currentQuestion]["Equations"];
    var answer = data[currentQuestion]["Answers"][0];

    var question = '';
    var varSave = new Map();
    List<String> answerList =
        []; //  for the different value for different equations

    // Stage 1: Randomize value for different variables and save them to varSave
    int currentID = 0;
    while (currentID < questionRaw.length) {
      var currentChar = questionRaw[currentID];
      if (currentChar != '~') {
        question += currentChar;
      } else {
        for (int i = 0; i < variables.length; i++) {
          String currentProcess = "";
          for (int j = 0; j < variables[i]["VarName"].length; j++) {
            currentProcess = currentProcess + questionRaw[currentID + 1 + j];
          }
          if (variables[i]["VarName"] == currentProcess) {
            if (!varSave.containsKey(variables[i]["VarName"])) {
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

            question += varSave[variables[i]["VarName"]].toString();
            int length = variables[i]["VarName"].length;
            currentID = currentID + length;
            break;
          }
        }
      }
      currentID++;
    }

    print(varSave);

    int i = 0;
    for (i = 0; i < equations.length; i++) {
      //Stage 2: Start to replace variable with their corresponding variables

      String currentRawEquation = equations[
          i]; // take the current Equation, which contains the variable name
      String currentEquation = "";
      int curEqId =
          0; // use to process the String, to take out all of the String variable and replace with numerical value

      while (curEqId < currentRawEquation.length) {
        if (currentRawEquation[curEqId] == "~") {
          for (int j = 0; j < varSave.keys.length; j++) {
            String curProcess = "";
            for (int k = 0; k < varSave.keys.elementAt(j).length; k++) {
              curProcess = curProcess + currentRawEquation[curEqId + k + 1];
            }
            if (curProcess == varSave.keys.elementAt(j)) {
              currentEquation =
                  currentEquation + varSave[curProcess].toString();
              curEqId = curEqId + curProcess.length;
              break;
            }
          }
        } else {
          currentEquation = currentEquation + currentRawEquation[curEqId];
        }
        curEqId = curEqId + 1;
      }

      //Stage 3: Evaluabte the equation
      if (currentEquation.length > 2) {
        if (currentEquation.substring(0, 2) == "!!") {
          String res = nonMathParser(currentEquation).toString();
          print(res);
          answerList.add(res);
        } else {
          ContextModel cm = ContextModel();
          print(currentEquation);
          Expression exp = p.parse(currentEquation);

          double res = exp.evaluate(EvaluationType.REAL, cm);

          if (res == res.roundToDouble()) {
            answerList.add(res.toInt().toString());
          } else {
            answerList.add(res.toStringAsFixed(2));
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
          answerList.add(res.toStringAsFixed(2));
        }
      }
    }

    String curAnswer = ""; //answer including the value (already replace ~^~)
    var curValueID = 0; //current ID of the list answerList - storing the

    i = 0; //id processing for the answer String
    while (i < answer.length) {
      if (i + 2 >= answer.length) {
        curAnswer = curAnswer + answer[i];
        i++;
      } else {
        String checkString = ""; //string to help process the current Answer;
        for (int j = i; j <= i + 2; j++) {
          checkString = checkString + answer[j];
        }
        if (checkString == "~^~") {
          curAnswer = curAnswer + answerList[curValueID];
          curValueID++;
          i = i + 3;
        } else {
          curAnswer = curAnswer + answer[i];
          i++;
        }
      }
    }

    //TODO: delete later
    print("Answer is " + curAnswer);
    print("Answer variable is: ");
    print(answerList);

    //end: we will get the answer value, with all the Value and string in it already

    return new Question2(question, type, equations, answer, curAnswer,
        answerList, varSave, topic, imagePath);
  }
}

//submit: TextField string
//equation: answerEquation
// String checkAnswerRandomFRQ_2(
//     var submit, var answer, var answerVar, var equation) {
//   equation = equation.trim().replaceAll(" ", "");
//   answer = answer.trim().replaceAll(" ", "");
//   submit = submit.text.trim().replaceAll(" ", "");

//   print(submit);
//   print(answer);
//   print(equation);

//   List<double> valueList = [];

//   // compare the non_numerical part of the submitted answer to equation
//   int equationId = 0;
//   int submitId = 0;

//   while (equationId < equation.length) {
//     if (equation.length - 1 - (equationId + 2) > 0) {
//       if (equation.substring(equationId, equationId + 3) == "~^~") {
//         equationId = equationId + 3;
//         String currentNumericalValue = "";
//         while (submit[submitId] != equation[equationId]) {
//           currentNumericalValue = currentNumericalValue + submit[submitId];
//           submitId++;
//         }
//         print("numberical value: " + currentNumericalValue);
//         valueList.add(double.parse(currentNumericalValue));
//       } else {
//         if (equation[equationId] == submit[submitId]) {
//           equationId++;
//           submitId++;
//         } else {
//           return "That is not the correct answer! The answer should be: " +
//               answer;
//         }
//       }
//     } else if (equation.length - 1 - (equationId + 2) == 0) {
//       if (equation.substring(equationId, equationId + 3) == "~^~") {
//         equationId = equationId + 3;
//         String currentNumericalValue = submit.substring(submitId);
//         if (isNumeric(equation)) {
//           valueList.add(double.parse(currentNumericalValue));
//         } else {
//           return "That is not the correct answer! The answer should be: " +
//               answer;
//         }
//       } else {
//         if (equation[equationId] == submit[submitId]) {
//           equationId++;
//           submitId++;
//         } else {
//           print(equation[equationId]);
//           print(submit[submitId]);
//           return "That is not the correct answer! The answer should be: " +
//               answer;
//         }
//       }
//     } else {
//       if (equation[equationId] == submit[submitId]) {
//         equationId++;
//         submitId++;
//       } else {
//         print("here");
//         print(equation[equationId]);
//         print(answer[submitId]);
//         return "That is not the correct answer! The answer should be: " +
//             answer;
//       }
//     }
//   }

//   if (submitId < submit.length - 1) {
//     print("diff");
//     return "That is not the correct answer! The answer should be: " + answer;
//   } else {
//     int i = 0;
//     for (int i = 0; i < answerVar.length; i++) {
//       double currentAnswerVar = double.parse(answerVar[i]);
//       print("var");
//       print(currentAnswerVar);
//       print(valueList[i]);
//       print(currentAnswerVar.compareTo(valueList[i]));
//       if (currentAnswerVar.compareTo(valueList[i]) == 0) {
//         i++;
//       } else {
//         print(answerVar[i]);
//         print(valueList[i]);
//         return "That is not the correct answer! The answer should be: " +
//             answer;
//       }
//     }
//   }

//   return "This is correct!";
// }

//a is a TextList Controller
String checkAnswerRandomFRQ(var a, var answer) {
  if (a.text.trim().isEmpty) {
    return "Please input your answer!";
  } else {
    var submit = a.text.trim().replaceAll(" ", "");
    answer = answer.trim().replaceAll(" ", "");

    print("debug");
    print('answer: ' + answer);
    print('submit: ' + submit);

    int answerID = 0; //used to process the string answer
    int submitID = 0; //used to process the string submit

    var currentAnswer = "";
    var currentSubmit = "";

    print(answer[0]);
    print(submit[0]);

    var isNumAnswer = isNumeric(answer[0]);
    var isNumSubmit = isNumeric(submit[0]);

    if (isNumAnswer != isNumSubmit) {
      return "That is not the correct answer! The answer should be: " + answer;
    }

    int i = 0;
    while (answerID < answer.length) {
      i++;

      while (answerID < answer.length) {
        if (isNumAnswer == isNumeric(answer[answerID])) {
          currentAnswer = currentAnswer + answer[answerID];
          answerID = answerID + 1;
        } else {
          break;
        }
      }

      while (submitID < submit.length) {
        if (isNumSubmit == isNumeric(submit[submitID])) {
          currentSubmit = currentSubmit + submit[submitID];
          submitID = submitID + 1;
        } else {
          break;
        }
      }

      if (isNumAnswer == false) {
        if (currentAnswer != currentSubmit) {
          return "That is not the correct answer! The answer should be: " +
              answer;
        }
      } else {
        if ((double.parse(currentAnswer) - double.parse(currentSubmit)).abs() >=
            0.1) {
          print("here");
          return "That is not the correct answer! The answer should be: " +
              answer;
        }
      }

      isNumAnswer = turnTrueFalse(isNumAnswer);
      isNumSubmit = turnTrueFalse(isNumSubmit);
      currentAnswer = "";
      currentSubmit = "";

      break;
    }

    if (submitID < a.text.length) {
      return "That is not the correct answer! The answer should be: " + answer;
    }

    return "This is correct!";
  }
}

// a is a TextListController
String checkAnswerFRQ(var a, var answer) {
  int num = a.length;
  var display;
  for (int i = 1; i <= a.length; i++) {
    var current = answer.elementAt(i - 1);
    for (int k = 0; k < current.length; k++) {
      current[k] = current[k].trim().toLowerCase();
    }

    for (int j = 0; j < a.length; j++) {
      if (current.contains(a.elementAt(j).text.trim().toLowerCase())) {
        num = num - 1;
        break;
      }
    }
  }

  if (num == 0) {
    return "This is correct!";
  } else {
    display = "The answer is not correct, it should be ";
    for (int i = 0; i < a.length - 1; i++) {
      display = display + answer.elementAt(i)[0] + ", ";
    }
    display = display + answer.elementAt(a.length - 1)[0];
    return display;
  }
}

String checkMultipleChoice(var choice, var student_choice, var answer) {
  if (student_choice == answer) {
    return "This is correct!";
  } else {
    return "That is not the correct answer! The answer should be: " +
        choice[answer];
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

bool turnTrueFalse(bool a) {
  if (a == true) {
    return false;
  } else {
    return true;
  }
}

bool isNumeric(String s) {
  if (s == ".") {
    return true;
  }
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
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
  final appStorage = await getApplicationDocumentsDirectory();
  final file = File('${appStorage.path}/Image/$name');

  final response = await Dio().get(url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ));

  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();
}

//save the progress to the current file
Future<List<Test>> saveProgress(var currentTest, var currentTestList) async {
  //initialize file path
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  final progressFile = File('$appDocPath/progress.txt');

  //add the new test progress into the current testList
  currentTestList.add(currentTest);

  //remove the two test with the same name
  //TODO: think of a better efficient way
  var seen = Set<String>();
  List<Test> uniqueTest =
      currentTestList.where((test) => seen.add(test.getName())).toList();
  //currentTestList = uniqueTest;

  //log down the progress file
  progressFile.writeAsStringSync(jsonEncode(uniqueTest));

  return uniqueTest;
}

Future<bool> checkFirstTime() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  final progressFile = File('$appDocPath/progress.txt');

  if (progressFile.existsSync()) {
    return false;
  } else {
    print("here");
    return true;
  }
}

//read the progress from the file and update the test
Future<List<Test>> readProgress() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
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

// return course name and current list name
Future<Set<String>> updateTestFile() async {
  //setting up application directory
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

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

    //looping over all of the items to find the names for the course and potentially unnits
    for (var o in jsonResponse.results as List<ParseObject>) {
      String? currentCourse = o.get<String>('Course');
      if (!courseList1.contains(currentCourse)) {
        courseList1.add(currentCourse);
      }
    }

    //courseList2 isa duplicate of courseList1, in order to loop over and adjust
    // the unit file.
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
        var directory = await Directory('$appDocPath/' + courseList2.first)
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

  updateImageFile();
  return courseSet;
}

// return course name and current list name
void updateImageFile() async {
  //setting up application directory
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

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
    var imageDirectory =
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

      var localImage = downloadFileImage(imageURL!, currentImageName!);
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
}
