import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'QuestionPage.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import '../back_end/back_end.dart';

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
                  //update question List based on the selection

                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  //question path file
                  var questionFile = File('$appDocPath/' +
                      widget.course +
                      '/' +
                      widget.unitList!.elementAt(index) +
                      '.txt');
                  String questionString = await questionFile.readAsString();
                  test_file = jsonDecode(questionString);
                  questionNum = test_file.keys.length;
                  currentQ = getQuestionInfo(test_file, cur);

                  var list = new List<dynamic>.generate(questionNum, (i) => i);
                  list = shuffle(list);

                  for (int i = 0; i < questionNum; i++) {
                    stdout.write("A: " + list.elementAt(i).toString());
                    questionOrder.add(list.elementAt(i));
                  }

                  print(currentQ.getQuestion());

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
