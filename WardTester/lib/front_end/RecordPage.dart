import 'package:flutter/material.dart';
import 'ProgressPage.dart';
import 'HomePage.dart';
import 'CompleteRecordPage.dart';
import '../main.dart';

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

// textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2979FF),
//                         fontSize: 30.0)

TextStyle header = new TextStyle(fontWeight: FontWeight.bold);
