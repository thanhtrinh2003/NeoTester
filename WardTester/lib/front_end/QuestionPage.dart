import 'package:flutter/material.dart';
import "QuestionView.dart";
import "ProgressBar.dart";
import '../main.dart';

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
          title: Text(widget.setName),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(child: Text("Question")),
              Tab(child: Text("Progress")),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: QuestionView(),
            ),
            Center(
              child: ProgressBar(),
            ),
          ],
        ),
      ),
    );
  }
}
