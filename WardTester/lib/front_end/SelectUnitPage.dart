import 'package:flutter/material.dart';
import '../main.dart';
import 'QuestionPage.dart';

class SelectUnitPage extends StatefulWidget {
  final unitList;
  const SelectUnitPage({Key? key, this.unitList}) : super(key: key);

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
          itemCount: widget.unitList!.length,
          itemBuilder: (BuildContext context, int index) {
            return RaisedButton(
              child: Center(
                  child: Text(widget.unitList!.elementAt(index),
                      style: TextStyle(color: Colors.white, fontSize: 18))),
              padding: const EdgeInsets.all(8),
              color: Color(0xFF2979FF),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionPage(),
                  ),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ));
  }
}
