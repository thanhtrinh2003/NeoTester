import 'package:flutter/material.dart';
import 'SelectUnitPage.dart';
import '../main.dart';
import '../back_end/utils.dart';
import "dart:io";
import 'package:path_provider/path_provider.dart';

class CompleteRecordPage extends StatefulWidget {
  const CompleteRecordPage({Key? key}) : super(key: key);

  @override
  _CompleteRecordPageState createState() => _CompleteRecordPageState();
}

class _CompleteRecordPageState extends State<CompleteRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: completeTestList == null ? 1 : completeTestList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              //return the header
              return new Row(
                children: <Widget>[
                  Expanded(
                      child: Text("Name",
                          textAlign: TextAlign.center, style: header),
                      flex: 3),
                  Expanded(
                      child: Text("Time Start",
                          textAlign: TextAlign.center, style: header),
                      flex: 2),
                  Expanded(
                      child: Text("Time End",
                          textAlign: TextAlign.center, style: header),
                      flex: 1),
                  Expanded(
                      child: Text("Question Left",
                          textAlign: TextAlign.center, style: header),
                      flex: 1),
                  Expanded(
                      child: Text("Accuracy",
                          textAlign: TextAlign.center, style: header),
                      flex: 1),
                ],
              );
            } else {
              index -= 1;

              //return row
              var row = completeTestList[index];
              return ListTile(
                  onTap: null,
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(completeTestList[index].getName(),
                              textAlign: TextAlign.center),
                          flex: 3),
                      Expanded(
                          child: Text(completeTestList[index].getTimeStart(),
                              textAlign: TextAlign.center),
                          flex: 2),
                      Expanded(
                          child: Text(completeTestList[index].getTimeEnd(),
                              textAlign: TextAlign.center),
                          flex: 1),
                      Expanded(
                          child: Text(
                              completeTestList[index]
                                  .getQuestionLeft()
                                  .toString(),
                              textAlign: TextAlign.center),
                          flex: 1),
                      Expanded(
                          child: Text(
                              completeTestList[index]
                                  .getAccuracy()
                                  .toStringAsFixed(3)
                                  .toString(),
                              textAlign: TextAlign.center),
                          flex: 1)
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

// textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2979FF),
//                         fontSize: 30.0)

TextStyle header = new TextStyle(fontWeight: FontWeight.bold);
