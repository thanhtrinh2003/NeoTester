import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/utilities.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../back_end/Test.dart';

class MultipleChoice extends StatefulWidget {
  const MultipleChoice({Key? key}) : super(key: key);

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        currentQ.getImagePath() != ""
            ? Image.asset(currentQ.getImagePath(), scale: 0.8)
            : SizedBox.shrink(),
        SizedBox(
          height: 10,
        ),
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
              TextSpan(
                  text: currentQ.getQuestion(),
                  style: TextStyle(fontSize: 16, color: Colors.black))
            ])),
        ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: currentQ.getChoice().length,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
                child: Text(currentQ.getChoice()[index]),
                onPressed: () => setState(() {
                      studentChoice = index;
                      resultDisplay =
                          "Answer is: " + currentQ.getChoice()[index];
                    }));
            // return TextField(
            //     controller: textListController?.elementAt(index),
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       hintText: 'Enter the answer',
            //     ));
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
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
                  resultDisplay = checkMultipleChoice(currentQ.getChoice(),
                      studentChoice, currentQ.getAnswer());
                  setState(() {
                    if (resultDisplay == "This is correct!") {
                      questionOrder.removeFirst();
                      currentTest.incrementAttempt();
                    } else {
                      // question answer wrong, so add the same question back to the end of the queue
                      // remove it at first
                      questionOrder.add(questionOrder.first);
                      questionOrder.removeFirst();
                      currentTest.incrementAttempt();
                    }
                    buttonQuestionText = "Next";
                    stateButton = -stateButton;
                  });
                } else {
                  cur = cur + 1;
                  resultDisplay = "";
                  buttonQuestionText = "Submit";
                  stateButton = -stateButton;

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
                    saveProgress(currentTest, testList)
                        .then((List<Test> value) {
                      testList = value;
                    });

                    //go to the next question page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage()));
                  } else {
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
            ))
      ],
    );
  }
}
