import 'package:flutter/material.dart';
import '../main.dart';

class NameSetPage extends StatefulWidget {
  const NameSetPage({Key? key}) : super(key: key);

  @override
  NameSetPageState createState() => NameSetPageState();
}

class NameSetPageState extends State<NameSetPage> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2979FF),
        elevation: 4,
        automaticallyImplyLeading: false,
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.scaleDown,
                ),
                TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the answer",
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () async {
                          studentName = myController.text;
                        },
                        child: Text(buttonQuestionText),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF2979FF))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
