import 'package:flutter/material.dart';
import 'SelectUnitPage.dart';
import '../main.dart';
import '../back_end/utilities.dart';
import "dart:io";
import 'package:path_provider/path_provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2979FF),
          automaticallyImplyLeading: true,
          title: Text(
            'Select Course',
            //
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: testList == null ? 1 : testList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              //return the header
              return new Row(
                children: <Widget>[
                  Expanded(child: Text("Name")),
                  Expanded(child: Text("Time Start")),
                  Expanded(child: Text("Time End")),
                  Expanded(child: Text("Question Left")),
                ],
              );
            } else {
              index -= 1;

              //return row
              var row = testList[index];
              return ListTile(
                  onTap: null,
                  title: Row(
                    children: <Widget>[
                      Expanded(child: Text(testList[index].getName())),
                      Expanded(child: Text(testList[index].getTimeStart())),
                      Expanded(child: Text(testList[index].getTimeEnd())),
                      Expanded(
                          child: Text(
                              testList[index].getQuestionLeft().toString())),
                    ],
                  ));
            }
            ;
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ));
  }
}
