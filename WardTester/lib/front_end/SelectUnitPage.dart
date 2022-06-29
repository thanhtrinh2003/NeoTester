import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'QuestionPage.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import '../back_end/utilities.dart';
import '../back_end/Test.dart';

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
              child: RaisedButton(
                child: Center(
                    child: Text(widget.unitList!.elementAt(index),
                        style: TextStyle(color: Colors.white, fontSize: 18))),
                padding: const EdgeInsets.all(8),
                color: Color(0xFF2979FF),
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

                  //take the ffirst question out
                  questionNum = test_file.keys.length;
                  currentQ = getQuestionInfo(test_file, cur);

                  //add the deivice directories, if null no need to add
                  if (currentQ.getImagePath() != "") {
                    currentQ.setImagePath(
                        '$appDocPath/Image/' + currentQ.getImagePath());
                  }

                  //question order taken from the testList
                  if (testList != null) {
                    //find the correct Test with the corresponding name --> take question Order
                    Test findTest(String name) =>
                        testList.firstWhere((test) => test.getName() == name);
                    questionOrder = findTest(widget.unitList!.elementAt(index))
                        .getQuestionOrder();
                  } else {
                    //create a random question order based on the number of question in the test
                    var list =
                        new List<dynamic>.generate(questionNum, (i) => i);
                    list = shuffle(list);
                    for (int i = 0; i < questionNum; i++) {
                      questionOrder.add(list.elementAt(i));
                    }
                  }

                  // read the progress

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
