import 'package:flutter/material.dart';
import '../main.dart';
import 'SelectCoursePage.dart';
import 'ProgressPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF2979FF), elevation: 4),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Align(
            alignment: AlignmentDirectional(0, 0.45),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(' \nWelcome\nto the \nWardTester',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2979FF),
                        fontSize: 30.0)),
                Image.asset(
                  'assets/LaunchImageHR.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.scaleDown,
                ),
                Align(
                  alignment: AlignmentDirectional(0, -0.05),
                  child: RaisedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SelectCoursePage(courseList: courseList),
                          ),
                        );
                      },
                      color: Color(0xFF2979FF),
                      child: Text("Start Test"),
                      textColor: Color(0xFFFAFAFA)),
                ),
                Align(
                  alignment: AlignmentDirectional(0, -0.05),
                  child: RaisedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgressPage(),
                          ),
                        );
                      },
                      color: Color(0xFF2979FF),
                      child: Text("Progress"),
                      textColor: Color(0xFFFAFAFA)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
