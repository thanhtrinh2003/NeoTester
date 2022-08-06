import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/utilities.dart';
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
                text: resultDisplay,
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
                  resultDisplay =
                      checkAnswerRandomFRQ(myController, currentQ.getAnswer());
                  if (resultDisplay == "This is correct!") {
                    questionOrder.removeFirst();

                    currentTest.incrementCorrect();
                    currentTest.incrementAttempt();
                  } else {
                    questionOrder.add(questionOrder.first);
                    questionOrder.removeFirst();

                    currentTest.incrementAttempt();
                  }
                });
                //answerDisplay = checkAnswerFRQ(
                //textListController, currentQ.getAnswer()),
                if (resultDisplay != "Please input your answer!") {
                  setState(() {
                    buttonQuestionText = "Next";
                    stateButton = -stateButton;
                  });
                }
              } else {
                resultDisplay = "";
                cur = cur + 1;
                setState(() {
                  buttonQuestionText = "Submit";
                  stateButton = -stateButton;
                });
                //Case: Still there is question
                if (questionOrder.isNotEmpty) {
                  currentQ = getQuestionInfo(test_file, questionOrder.first);

                  //TODO: delete this later
                  print("Question: " + currentQ.getQuestion());
                  print("Question: " + currentQ.getImagePath());

                  //add the imagepath for next question display
                  if (currentQ.getImagePath() != "") {
                    currentQ.setImagePath(
                        "$appDocPath/Image/" + currentQ.getImagePath());
                  }

                  //save the progress
                  currentTest.setQuestionOrder(questionOrder);
                  saveProgress(currentTest, testList);

                  //go to the next question page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QuestionPage()));
                }
                //Case: No more question
                else {
                  cur = 0;
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
