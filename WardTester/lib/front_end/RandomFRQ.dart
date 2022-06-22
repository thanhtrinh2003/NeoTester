import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/back_end.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RandomFRQ extends StatefulWidget {
  const RandomFRQ({Key? key}) : super(key: key);

  @override
  State<RandomFRQ> createState() => _RandomFRQState();
}

class _RandomFRQState extends State<RandomFRQ> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      currentQ.getImagePath() != ""
          ? Image.asset(currentQ.getImagePath())
          : SizedBox.shrink(),
      RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                text: currentQ.getQuestion(),
                style: TextStyle(fontSize: 16, color: Colors.black))
          ])),
      TextField(
          controller: myController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter the answer",
          )),
      RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                text: answerDisplay,
                style: TextStyle(fontSize: 12, color: Colors.black))
          ])),
      Container(
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              Directory appDocDir = await getApplicationDocumentsDirectory();
              String appDocPath = appDocDir.path;

              if (stateButton == 1) {
                //control the progress stats for the current question
                setState(() {
                  answerDisplay =
                      checkAnswerRandomFRQ(myController, currentQ.getAnswer());
                  if (answerDisplay == "This is correct!") {
                    correctNum++;
                    questionOrder.removeFirst();
                  } else {
                    questionOrder.add(questionOrder.first);
                    questionOrder.removeFirst();
                  }
                });
                //answerDisplay = checkAnswerFRQ(
                //textListController, currentQ.getAnswer()),
                if (answerDisplay != "Please input your answer!") {
                  setState(() {
                    buttonQuestionText = "Next";
                    stateButton = -stateButton;
                  });
                }
              } else {
                answerDisplay = "";
                cur = cur + 1;
                setState(() {
                  buttonQuestionText = "Submit";
                  stateButton = -stateButton;
                });
                if (questionOrder.isNotEmpty) {
                  currentQ = getQuestionInfo(test_file, questionOrder.first);
                  if (currentQ.getImagePath() != null) {
                    currentQ.setImagePath(
                        "$appDocPath/Image/" + currentQ.getImagePath());
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QuestionPage()));
                } else {
                  cur = 0;
                  // we will change to
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              }
            },
            child: Text(buttonQuestionText),
          ))
    ]);
  }
}
