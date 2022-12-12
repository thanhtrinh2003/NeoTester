import 'package:flutter/material.dart';
import '../main.dart';
import 'test_screens/QuestionPage.dart';
import "dart:core";
import '../back_end/utils.dart';
import 'SelectCoursePage.dart';

class SelectUnitPage extends StatefulWidget {
  final unitList;
  final course;
  const SelectUnitPage({Key? key, this.unitList, this.course})
      : super(key: key);

  @override
  _SelectUnitPageState createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2979FF),
          automaticallyImplyLeading: true,
          title: Text(
            'Select Unit',
            //
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectCoursePage(courseList: courseList),
                ),
              );
            },
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: widget.unitList!.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.01,
              child: ElevatedButton(
                child: Center(
                    child: Text(widget.unitList!.elementAt(index),
                        style: TextStyle(color: Colors.white, fontSize: 18))),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  primary: Color(0xFF2979FF),
                ),
                onPressed: () async {
                  String course = widget.course;
                  String unit = widget.unitList!.elementAt(index);
                  await startTest(course, unit);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionPage(),
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
