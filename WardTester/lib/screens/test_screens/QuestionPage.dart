import 'package:flutter/material.dart';
import 'QuestionView.dart';
import 'ProgressGraph.dart';
import '../SelectUnitPage.dart';
import '../../main.dart';

class QuestionPage extends StatefulWidget {
  final String setName;

  const QuestionPage({Key? key, this.setName = 'Question Page'})
      : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF2979FF),
            title: Text(widget.setName),
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
