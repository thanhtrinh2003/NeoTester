import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/utils.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../back_end/Test.dart';

class RandomFRQ extends StatefulWidget {
  const RandomFRQ({Key? key}) : super(key: key);

  @override
  State<RandomFRQ> createState() => _RandomFRQState();
}

class _RandomFRQState extends State<RandomFRQ> {
  final submittedAnswerText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      currentQ.getImagePath() != ""
          ? Image.asset(currentQ.getImagePath(), scale: 0.8)
          : SizedBox.shrink(),
      RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                text: currentQ.getQuestion(),
                style: TextStyle(fontSize: 19, color: Colors.black))
          ])),
      TextField(
          autofocus: true,
          controller: submittedAnswerText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "If needed, use at least 3 decimal places",
          )),
      RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                text: resultDisplay,
                style: TextStyle(fontSize: 14, color: Colors.black))
          ])),
      Container(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () async {
                if (!hasSubmitted) {
                  //control the progress stats for the current question
                  setState(() {
                    submitPressed(currentQ.isCorrect(submittedAnswerText));
                  });
                } else {
                  if (nextPressedIsMoreQuestions()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                }
              },
              child: Text(submitButtonText),
              style: ElevatedButton.styleFrom(primary: Color(0xFF2979FF))))
    ]);
  }
}
