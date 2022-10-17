import 'package:flutter/material.dart';
import '../main.dart';
import 'SelectCoursePage.dart';
import 'ProgressPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../back_end/utils.dart';
import 'HomePage.dart';
import 'NameSetPage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            updateTestFile(), // the function to get your data from firebase or firestore
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return Scaffold(
              backgroundColor: Colors.blue.shade600,
              body: Center(
                  child: SpinKitCubeGrid(size: 140, color: Colors.white)),
            );
          } else if (studentName != "null") {
            courseList = snap.data;
            return HomePage();
            //return the widget that you want to display after loading
          } else {
            return NameSetPage();
          }
        });
  }
}
