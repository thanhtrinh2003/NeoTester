import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import 'package:path_provider/path_provider.dart';
import 'math_function.dart';
import 'dart:convert';
import 'math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'Test.dart';
import 'Question.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'Test.dart';

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

    // adding the variables' randomized value to a list called VarSave
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
            double current = generateRandom(
                variables[i]["LowerBound"].toDouble(),
                variables[i]["UpperBound"].toDouble(),
                variables[i]["Step"].toDouble());
            varSave[variables[i]["VarName"]] = current; // take the one use out
            question += current.toStringAsFixed(2).toString();
            int length = variables[i]["VarName"].length;
            currentID = currentID + length;
            break;
          }
        }
      }
      currentID++;
    }

    //start: put this in a while, every time get teh value and then save it into a list, and then paste it all in the answer

    for (int i = 0; i < equations.length; i++) {
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
              currentEquation = currentEquation +
                  varSave[curProcess].toStringAsFixed(3).toString();
              curEqId = curEqId + curProcess.length;
              break;
            }
          }
        } else {
          currentEquation = currentEquation + currentRawEquation[curEqId];
        }
        curEqId = curEqId + 1;
      }

      ContextModel cm = ContextModel();
      Expression exp = p.parse(currentEquation);

      String res =
          exp.evaluate(EvaluationType.REAL, cm).toStringAsFixed(3).toString();

      answerList.add(res);

      break;
    }

    String curAnswer = ""; //answer including the value (already replace ~^~)
    var curValueID = 0; //current ID of the list answerList - storing the

    int i = 0; //id processing for the answer String
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
    print("Answer is " + curAnswer);

    //end: we will get the answer value, with all the Value and string in it already

    return new Question2(
        question, type, equations, curAnswer, varSave, topic, imagePath);
  }
}

//a is a TextList Controller
String checkAnswerRandomFRQ(var a, var answer) {
  if (a.text.trim().isEmpty) {
    return "Please input your answer!";
  } else {
    var submit = a.text.trim().replaceAll(" ", "");
    answer = answer.trim().replaceAll(" ", "");

    int answerID = 0; //used to process the string answer
    int submitID = 0; //used to process the string submit

    var currentAnswer = "";
    var currentSubmit = "";

    var isNumAnswer = isNumeric(answer[0]);
    var isNumSubmit = isNumeric(submit[0]);

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
            1) {
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

    return "This is correct";
  }
}

// a is a TextListController
String checkAnswerFRQ(var a, var answer) {
  int num = a.length;
  var display;
  for (int i = 1; i <= a.length; i++) {
    var current = answer.elementAt(i - 1);
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
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
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
void saveProgress(var currentTest, var currentTestList) async {
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
  currentTestList = uniqueTest;

  //log down the progress file
  progressFile.writeAsStringSync(jsonEncode(currentTestList));
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
