import 'package:flutter/material.dart';
import 'SelectUnitPage.dart';
import '../main.dart';
import '../back_end/utilities.dart';
import "dart:io";
import 'package:path_provider/path_provider.dart';

class SelectCoursePage extends StatefulWidget {
  final Set<String>? courseList;
  const SelectCoursePage({Key? key, this.courseList}) : super(key: key);

  @override
  _SelectCoursePageState createState() => _SelectCoursePageState();
}

class _SelectCoursePageState extends State<SelectCoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2979FF),
          automaticallyImplyLeading: true,
          title: Text(
            'Select Course',
            //
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: widget.courseList!.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.1,
              child: RaisedButton(
                child: Center(
                    child: Text(widget.courseList!.elementAt(index),
                        style: TextStyle(color: Colors.white, fontSize: 18))),
                padding: const EdgeInsets.all(8),
                color: Color(0xFF2979FF),
                onPressed: () async {
                  //update unit list
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  var unitFile = File('$appDocPath/' +
                      widget.courseList!.elementAt(index) +
                      "/unit.txt");
                  String unitListContent = await unitFile.readAsString();
                  List<String> unitListNew = unitListContent.split(",");
                  unitList = unitListNew.toSet();

                  //update currentCourse and currentUnitList
                  currentCourse = widget.courseList!.elementAt(index);
                  currentUnitList = unitList;

                  //getting questions

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectUnitPage(
                          unitList: unitList,
                          course: widget.courseList!.elementAt(index)),
                    ),
                  );
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ));
  }
}
