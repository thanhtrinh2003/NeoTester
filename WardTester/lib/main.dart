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
  "sdfsdf"
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
  //getting data from Back4App for the

  //TODO: need to write the if else version, if equals then no need to download

  //if version is eqauls then no need to check
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'Jkk0zBewPQACbqAYHeL2C4rVFSvj1WXlTQtPRaQD';
  final keyClientKey = '9iTzK49uR12cJHM9qn3fiFsnVEYBqseYjZC18tqw';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  QueryBuilder<ParseObject> queryFile =
      QueryBuilder<ParseObject>(ParseObject('JSON'));
  final ParseResponse apiResponse = await queryFile.query();

  List<ParseObject> data1 = apiResponse.results as List<ParseObject>;

  //device Application apth checking
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  var url = Uri.parse(data1[0]["File"]["url"]);
  var response1 = await http.get(url);

  print(response1);

  var data = jsonDecode(response1.body);
  print(data);

  print(data.toString());

  final file = File('$appDocPath/test.txt');
  file.writeAsString(data.toString());

  //test

  // if (apiResponse.results != null) {
  //   for (var o in apiResponse.results as List<ParseObject>) {
  //     print(o.get<String>('Unit'));
  //   }
  // }

  //ParseFileBase? varFile = data1[0].get<ParseFileBase>('File');

  //TODO: Add all parse needed including parser

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
