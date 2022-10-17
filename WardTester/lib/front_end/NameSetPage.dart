import 'package:flutter/material.dart';
import 'HomePage.dart';
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
        title: Text("WardTeser"),
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
                controller: myController,
                decoration: InputDecoration(
                  hintText: "Please input your name!",
                ),
              )),
          SizedBox(height: 10),
          Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    studentName = myController.text;
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    );
                  },
                  child: Text(buttonQuestionText),
                  style: ElevatedButton.styleFrom(primary: Color(0xFF2979FF))))
        ],
      ),
    );
  }
}
