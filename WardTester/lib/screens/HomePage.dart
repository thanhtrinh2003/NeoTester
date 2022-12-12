import 'package:flutter/material.dart';
import 'package:trying/screens/helper_screens/NameSetPage.dart';
import '../main.dart';
import 'SelectCoursePage.dart';
import 'progress_screens/RecordPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2979FF),
        elevation: 4,
        automaticallyImplyLeading: false,
        title: Text('WardTester'),
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
                        title: Center(child: const Text("Change Name")),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "WARNING!!\nChanging name will delete all progress",
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
                              primary: Color(0xFF2979FF),
                            ),
                            child: Text("Continue",
                                style: TextStyle(color: Color(0xFFFAFAFA))),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NameSetPage(),
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            child: Text("Cancel",
                                style: TextStyle(color: Color(0xFFFAFAFA))),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF2979FF),
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
      ),
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
                  height: MediaQuery.of(context).size.height * 0.45,
                  fit: BoxFit.scaleDown,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectCoursePage(courseList: courseList),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF2979FF),
                  ),
                  child: Text("Start Test",
                      style: TextStyle(color: Color(0xFFFAFAFA))),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF2979FF),
                  ),
                  child: Text("Progress",
                      style: TextStyle(color: Color(0xFFFAFAFA))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
