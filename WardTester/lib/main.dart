// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'back_end/math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'back_end/back_end.dart';
import 'front_end/HomePage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:collection';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

//flutter run --no-sound-null-safety

// variables
const double pi = 3.1415926535897932;
const double e = 2.718281828459045;

String result = ""; // True or False with Real Answer
String eval = ""; // result of
var data; //storing the current question file under the JASON format
int cur = 0; // current question ID
var q;

var choice; // array of multiple choices value for question Type 0

//new variables
const String question_file = 'assets/test.json'; //data file
const Set<String> courseList = {
  "AP CS A",
  "AP CS P",
  "AP Statistics",
};
const unitList = {
  "AP CS A": [
    "Unit 1 -  One Variable",
    "Unit 2 - Location in a Distribution",
    "Unit 3 - Linear Regression"
  ],
  "AP CS P": ["Unit 1 P", "Unit 2 P", "Unit 3 P"],
  "AP Statistics": ["Unit 1", "Unit 2", "Unit 3"]
};

var test_file; // current question test file
var currentQ; // current question
var t = 1;
var answerDisplay = " "; // send out if the answer is correct or not
var buttonQuestionText = "Submit"; //button submit or next
var stateButton = 1; // 1: submit, -1: next
var studentChoice; //student answer for question Type 0
var varSave =
    new Map(); //saving current question variable value for the randomized FRQ
var questionNum; // number of questions for the current lesson
var correctNum =
    0; // number of questions that was answer correctly for the lessons
Random random = new Random();
Queue<int> questionOrder = new Queue<int>();

//application Document Path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //setting up application directory
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  print("Path for this device: " + appDocPath);

  //setting up back4app ID address
  final keyApplicationId = 'Jkk0zBewPQACbqAYHeL2C4rVFSvj1WXlTQtPRaQD';
  final keyClientKey = '9iTzK49uR12cJHM9qn3fiFsnVEYBqseYjZC18tqw';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  //setting up JSON File for verion file through Back4App Connection
  QueryBuilder<ParseObject> version =
      QueryBuilder<ParseObject>(ParseObject('JSON_Version'));
  final ParseResponse versionResponse = await version.query();
  List<ParseObject> versionList = versionResponse.results as List<ParseObject>;

  //setting up JSON File for question file through Back4App Connection
  QueryBuilder<ParseObject> jsonQuestionParse =
      QueryBuilder<ParseObject>(ParseObject("JSON"));
  final ParseResponse jsonResponse = await jsonQuestionParse.query();
  List<ParseObject> questionList = jsonResponse.results as List<ParseObject>;

  //check if there is an existing version file to download the questionFile or not
  final versionFile = File('$appDocPath/version.txt');

  if ((versionFile.existsSync() &&
          versionFile.readAsStringSync() != versionList[0]["date"]) ||
      !versionFile.existsSync()) {
    //TODO: remember to change the below condition from == to != because it is not testing anymore
    //variable for file save later
    Queue courseList1 = new Queue<String>();

    //looping over all of the items to find the names for the course and potentially unnits
    for (var o in jsonResponse.results as List<ParseObject>) {
      String? currentCourse = o.get<String>('Course');
      if (!courseList1.contains(currentCourse)) {
        courseList1.add(currentCourse);
      }
    }

    Queue courseList2 = new Queue.from(courseList1);

    //initialize file path
    final courseFile = File('$appDocPath/course.txt');

    // process Queue into approriate String in the formate of List for use later
    String courseListFile = "[\"";
    int courseListLength = courseList1.length;
    for (int i = 0; i < courseListLength - 1; i++) {
      courseListFile = courseListFile + courseList1.first + "\", \"";
      courseList1.removeFirst();
    }
    courseListFile = courseListFile + courseList1.first + "\"]";
    courseFile.writeAsStringSync(courseListFile);

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
        String unitListFile = "[\"";
        int unitListLength = unitList1.length;

        for (int i = 0; i < unitListLength - 1; i++) {
          unitListFile = unitListFile +
              unitList1.first.substring(0, unitList1.first.indexOf('.')) +
              "\", \"";
          unitList1.removeFirst();
        }
        unitListFile = unitListFile +
            unitList1.first.substring(0, unitList1.first.indexOf('.')) +
            "\"]";

        //String to pass in for the file is stored in unitList File
        var direcwtory = await Directory('$appDocPath/' + courseList2.first)
            .create(recursive: true);
        var unitFile = File('$appDocPath/' + courseList2.first + "/unit.txt");
        unitFile.writeAsStringSync(unitListFile);

        courseList2.removeFirst();
      }
    }

    versionFile.writeAsString(versionList[0]["date"]);
  }

  //TODO: r url = Uri.parse(data1[0]["File"]["url"]);

  // var json_response = await http.get(url);
  // var data = jsonDecode(json_response.body);
  // final file = File('$appDocPath/test.txt');
  // file.writeAsString(data.toString());

  //ParseFileBase? varFile = data1[0].get<ParseFileBase>('File');

  //TOD: Add all parse needed including parser
  binomialCDF_parser();
  normalCDF_parser();

  // run App
  runApp(MyApp());
  final String response = await rootBundle.loadString(question_file);
  test_file = json.decode(response);
  questionNum = test_file.keys.length;
  currentQ = getQuestionInfo(test_file, cur);
  print(currentQ.getQuestion());

  //checking devices is phone or tablets, so that we can block the rotation later
  if (getDeviceType() == "phone") {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'MathTester',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
