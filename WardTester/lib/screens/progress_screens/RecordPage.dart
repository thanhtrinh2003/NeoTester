import 'package:flutter/material.dart';
import 'ProgressPage.dart';
import '../HomePage.dart';
import 'CompleteRecordPage.dart';
import '../../back_end/utils.dart';
import '../../back_end/Test.dart';
import '../../main.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF2979FF),
            title: Text("Progress - " + studentName),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Center(
                                child: const Text("Delete Curent Progress")),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "WARNING!!\nThis will delete all started but not completed test progress",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2979FF),
                                ),
                                child: Text("Continue",
                                    style: TextStyle(color: Color(0xFFFAFAFA))),
                                onPressed: () async {
                                  removeAllProgress();
                                  testProgressList =
                                      List<Test>.empty(growable: true);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text("Cancel",
                                    style: TextStyle(color: Color(0xFFFAFAFA))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2979FF),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          )); // do something
                },
              )
            ],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(child: Text("Current Test")),
                Tab(child: Text("Complete Test")),
              ],
            ),
            leading: BackButton(
              color: Colors.white,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            )),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: ProgressPage(),
            ),
            Center(
              child: CompleteRecordPage(),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle header = new TextStyle(fontWeight: FontWeight.bold);
