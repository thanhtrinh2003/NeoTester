import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'QuestionPage.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import "dart:core";
import '../back_end/utils.dart';
import '../back_end/Test.dart';
import 'SelectCoursePage.dart';
import 'dart:collection';

class SelectUnitPage extends StatefulWidget {
  final unitList;
  final course;
  const SelectUnitPage({Key? key, this.unitList, this.course})
      : super(key: key);

  @override
  _SelectUnitPageState createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2979FF),
          automaticallyImplyLeading: true,
          title: Text(
            'Select Unit',
            //
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectCoursePage(courseList: courseList),
                ),
              );
            },
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: widget.unitList!.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.01,
              child: ElevatedButton(
                child: Center(
                    child: Text(widget.unitList!.elementAt(index),
                        style: TextStyle(color: Colors.white, fontSize: 18))),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  primary: Color(0xFF2979FF),
                ),
                onPressed: () async {
                  //pull out correspsonding question file after selection
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;

                  //getting corresponding test file (consistings of questions)
                  var questionFile = File('$appDocPath/' +
                      widget.course +
                      '/' +
                      widget.unitList!.elementAt(index) +
                      '.txt');
                  String questionString = await questionFile.readAsString();
                  test_file = jsonDecode(questionString);

                  //total number of question
                  questionNum = test_file.keys.length;

                  print("num: " + questionNum.toString());

                  ///If the test list is not null, find the test that matches the name
                  /// - If there is not test, create one --> add into the testList, save progress
                  /// - If there is, that its questionOrder and paste it in our current question order
                  ///If the test list is null, create a test --> add it into the testList

                  if (testList != null) {
                    String currentTestName = currentCourse +
                        ": " +
                        widget.unitList!.elementAt(index);

                    //find the correct Test with the corresponding name --> take question Order
                    Test findTest(String name) =>
                        testList.firstWhere((test) => (test.getName() == name),
                            orElse: () => Test.nullOne());

                    currentTest = findTest(currentTestName);

                    if (currentTest.getName() == "null") {
                      //create a random question order based on the number of question in the test
                      questionOrder = new Queue();
                      var list =
                          new List<dynamic>.generate(questionNum, (i) => i);
                      list = shuffle(list);
                      for (int i = 0; i < questionNum; i++) {
                        questionOrder.add(list.elementAt(i));
                      }

                      //create a new Test Object
                      DateTime now = DateTime.now();
                      currentTest = new Test(currentTestName, questionOrder,
                          now, now, questionNum, 0);

                      // set the first question
                      currentQ =
                          getQuestionInfo(test_file, questionOrder.first);

                      //add the deivice directories for image , if null no need to add
                      if (currentQ.getImagePath() != "") {
                        currentQ.setImagePath(
                            '$appDocPath/Image/' + currentQ.getImagePath());
                      }

                      saveProgress(currentTest, testList);
                    } else {
                      questionOrder = currentTest.getQuestionOrder();
                      currentQ =
                          getQuestionInfo(test_file, questionOrder.first);

                      //add the deivice directories for image , if null no need to add
                      if (currentQ.getImagePath() != "") {
                        currentQ.setImagePath(
                            '$appDocPath/Image/' + currentQ.getImagePath());
                      }
                    }
                  } else {
                    //create a random question order based on the number of question in the test
                    var list =
                        new List<dynamic>.generate(questionNum, (i) => i);
                    list = shuffle(list);
                    for (int i = 0; i < questionNum; i++) {
                      questionOrder.add(list.elementAt(i));
                    }
                    // set the first question
                    currentQ = getQuestionInfo(test_file, questionOrder.first);
                    //add the deivice directories for image , if null no need to add
                    if (currentQ.getImagePath() != "") {
                      currentQ.setImagePath(
                          '$appDocPath/Image/' + currentQ.getImagePath());
                    }

                    //create a new Test Object
                    String currentTestName = currentCourse +
                        ": " +
                        widget.unitList!.elementAt(index);
                    DateTime now = DateTime.now();
                    currentTest = new Test(currentTestName, questionOrder, now,
                        now, questionNum, 0);

                    //update progress
                    testList = List<Test>.empty(growable: true);
                    saveProgress(currentTest, testList);
                  }

                  //TODO: delete this later
                  print(await currentQ.getQuestion());
                  print(questionFile);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionPage(),
                    ),
                  );
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ));
  }
}
