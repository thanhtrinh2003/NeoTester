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
  final myController = TextEditingController();
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
                style: TextStyle(fontSize: 14, color: Colors.black))
          ])),
      Container(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () async {
                Directory appDocDir = await getApplicationDocumentsDirectory();
                String appDocPath = appDocDir.path;

                if (stateButton == 1) {
                  //control the progress stats for the current question
                  setState(() {
                    resultDisplay = checkAnswerRandomFRQ(
                        myController, currentQ.getAnswer());
                    if (resultDisplay == "This is correct!") {
                      questionOrder.removeFirst();

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

                    //add the imagepath for next question display
                    if (currentQ.getImagePath() != "") {
                      currentQ.setImagePath(
                          "$appDocPath/Image/" + currentQ.getImagePath());
                    }

                    //save the progress
                    currentTest.setQuestionOrder(questionOrder);
                    saveProgress(currentTest, testList)
                        .then((List<Test> value) {
                      testList = value;
                    });

                    //go to the next question page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage()));
                  }
                  //Case: No more question
                  else {
                    cur = 0;

                    // set the end time for the test + save progress
                    currentTest.setTimeEnd(DateTime.now());

                    saveProgress(currentTest, testList)
                        .then((List<Test> value) {
                      testList = value;
                    });

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                }
              },
              child: Text(buttonQuestionText),
              style: ElevatedButton.styleFrom(primary: Color(0xFF2979FF))))
    ]);
  }
}
