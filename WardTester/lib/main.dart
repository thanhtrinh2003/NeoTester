// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'back_end/math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'back_end/utilities.dart';
import 'back_end/Test.dart';
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

//variables
const String question_file = 'assets/test.json'; //data file
var courseList;
var unitList;

/// current question test file
var test_file;

/// current question
var currentQ;
var t = 1;

//// send out if the answer is correct or not
var resultDisplay = " ";

///button submit or next
var buttonQuestionText = "Submit";

///1: submit, -1: next
var stateButton = 1;

///student answer for question Type 0
var studentChoice;

var varSave =
    new Map(); //saving current question variable value for the randomized FRQ
var questionNum; // number of questions for the current lesson
var correctNum =
    0; // number of questions that was answer correctly for the lessons
var testList; // current progress (containes many different test)
var currentTest; // current test (Test Object)
Random random = new Random();
Queue<int> questionOrder = new Queue<int>(); //current question order

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          versionFile.readAsStringSync() != versionList[0]["date"]) ||
      !versionFile.existsSync()) {
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

    //print out version
    versionFile.writeAsString(versionList[0]["date"]);
  }

  //checking current version for image
  version.whereEqualTo("dataType", "imageFile");
  final ParseResponse imageVersionResponse = await version.query();
  List<ParseObject> imageVersionList =
      imageVersionResponse.results as List<ParseObject>;
  final imageVersionFile = File('$appDocPath/imageVersion.txt');
  if ((imageVersionFile.existsSync() &&
          imageVersionFile.readAsStringSync() != imageVersionList[0]["date"]) ||
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
    imageVersionFile.writeAsString(imageVersionList[0]["date"]);
  }

  // update the course List in the form of set;
  String courseListContent = await courseFile.readAsString();
  List<String> courseListNew = courseListContent.split(", ");
  var courseSet = courseListNew.toSet();
  courseList = courseSet;

  //Read in the progress file
  final progressFile = File('$appDocPath/progress.txt');

  // update progress file (no need for first time)
  if (progressFile.existsSync()) {
    //read the progress file + change from Future<Test<List>> to Test<List>
    readProgress().then((List<Test> value) {
      testList = value;
    });
  } else {
    final progressFile = File('$appDocPath/progress.txt');
    progressFile.create();
  }

  //TOD: Add all parse nxeeded including parser
  binomialCDF_parser();
  normalCDF_parser();

  // run App
  runApp(MyApp());

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
