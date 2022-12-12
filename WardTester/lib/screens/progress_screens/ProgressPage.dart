import 'package:flutter/material.dart';
import '../../main.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: testProgressList == null ? 1 : testProgressList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              //return the header
              return new Row(
                children: <Widget>[
                  Expanded(
                      child: Text("Name",
                          textAlign: TextAlign.center, style: header),
                      flex: 6),
                  Expanded(
                      child: Text(" Start",
                          textAlign: TextAlign.center, style: header),
                      flex: 2),
                  Expanded(
                      child: Text("Qs Left",
                          textAlign: TextAlign.center, style: header),
                      flex: 1),
                  Expanded(
                      child: Text("Acc",
                          textAlign: TextAlign.center, style: header),
                      flex: 1),
                ],
              );
            } else {
              index -= 1;

              //return row
              return ListTile(
                onTap: null,
                title: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          testProgressList[index].getName(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9),
                        ),
                        flex: 6),
                    Expanded(
                        child: Text(
                          testProgressList[index]
                              .getTimeStart()
                              .substring(0, 10),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9),
                        ),
                        flex: 2),
                    Expanded(
                        child: Text(
                          testProgressList[index].getQuestionLeft().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9),
                        ),
                        flex: 1),
                    Expanded(
                        child: Text(
                          testProgressList[index]
                              .getAccuracy()
                              .toStringAsFixed(3)
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9),
                        ),
                        flex: 1)
                  ],
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
                visualDensity: VisualDensity(vertical: -4),
              );
            }
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
