import 'package:flutter/material.dart';
import 'QuestionView.dart';
import 'ProgressGraph.dart';
import '../SelectUnitPage.dart';
import '../../main.dart';
import '../../back_end/utils.dart';

class QuestionPage extends StatefulWidget {
  //final String unitName;

  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unitName = currentTest.getUnit();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF2979FF),
            title: Text(unitName),
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
                            title: Center(child: const Text("Restart Unit")),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "WARNING!!\nAll progress in this unit will be lost.",
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
                                child: Text("Restart",
                                    style: TextStyle(color: Color(0xFFFAFAFA))),
                                onPressed: () async {
                                  await restartUnit();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuestionPage()));
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
                Tab(child: Text("Question")),
                Tab(child: Text("Progress")),
              ],
            ),
            leading: BackButton(
              color: Colors.white,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectUnitPage(
                        unitList: currentUnitList, course: currentCourse),
                  ),
                );
              },
            )),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: QuestionView(),
            ),
            Center(
              child: ProgressGraph(),
            ),
          ],
        ),
      ),
    );
  }
}
