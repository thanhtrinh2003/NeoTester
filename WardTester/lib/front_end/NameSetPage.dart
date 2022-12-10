import 'dart:io';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import '../main.dart';

class NameSetPage extends StatefulWidget {
  const NameSetPage({Key? key}) : super(key: key);

  @override
  NameSetPageState createState() => NameSetPageState();
}

class NameSetPageState extends State<NameSetPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WardTester"),
        backgroundColor: Color(0xFF2979FF),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 30),
          Text('Registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2979FF),
                  fontSize: 30.0)),
          Image.asset(
            'assets/LaunchImageHR.png',
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.35,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                textAlign: TextAlign.center,
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: "Enter your first name",
                ),
              )),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                textAlign: TextAlign.center,
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: "Enter your last name",
                ),
              )),
          SizedBox(height: 10),
          Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    studentName = firstNameController.text +
                        " " +
                        lastNameController.text;
                    final nameFile = File("$appDocPath/name.txt");
                    nameFile.writeAsStringSync(studentName);
                    final progressFile = File("$appDocPath/progress.txt");
                    progressFile.writeAsStringSync("[]");
                    final completeFile = File("$appDocPath/complete.txt");
                    completeFile.writeAsStringSync("[]");
                    testList = [];
                    completeTestList = [];

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(primary: Color(0xFF2979FF))))
        ],
      ),
    );
  }
}
