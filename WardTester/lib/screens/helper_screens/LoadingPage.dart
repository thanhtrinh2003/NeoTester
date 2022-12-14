import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../back_end/utils.dart';
import '../HomePage.dart';
import 'NameSetPage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    loadNameFile().then((String value) {
      studentName = value;
      print("student: " + studentName);
    });

    return FutureBuilder(
        future: updateTestFile(), // the function to get your data from server
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return Scaffold(
              backgroundColor: Colors.blue.shade600,
              body: Center(
                  child: SpinKitCubeGrid(size: 140, color: Colors.white)),
            );
          } else if (studentName == "") {
            courseList = snap.data;
            return NameSetPage();
          } else {
            courseList = snap.data;
            return HomePage();
          }
        });
  }
}
