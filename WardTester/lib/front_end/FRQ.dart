import 'package:flutter/material.dart';
import '../back_end/utilities.dart';
import '../main.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FRQ extends StatefulWidget {
  const FRQ({Key? key}) : super(key: key);

  @override
  State<FRQ> createState() => _FRQState();
}

class _FRQState extends State<FRQ> {
  @override
  List<TextEditingController>? textListController = List.generate(
      currentQ.getAnswer().length, (index) => TextEditingController());

  Widget build(BuildContext context) {
    return Column(
      children: [
        currentQ.getImagePath() != ""
            ? Image.asset(currentQ.getImagePath())
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
          itemCount: currentQ.getAnswer().length,
          itemBuilder: (BuildContext context, int index) {
            return TextField(
                controller: textListController?.elementAt(index),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the answer',
                ));
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
                  resultDisplay =
                      checkAnswerFRQ(textListController, currentQ.getAnswer());
                  setState(() {
                    if (resultDisplay == "This is correct!") {
                      questionOrder.removeFirst();

                      currentTest.incrementAttempt();
                    } else {
                      questionOrder.add(questionOrder.first);
                      questionOrder.removeFirst();

                      currentTest.incrementAttempt();
                    }
                    buttonQuestionText = "Next";
                    stateButton = -stateButton;
                  });
                } else {
                  cur = cur + 1;
                  buttonQuestionText = "Submit";
                  resultDisplay = "";
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
                    saveProgress(currentTest, testList);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage()));
                  } else {
                    cur = 0;

                    // set the end time for the test + save progress
                    currentTest.setTimeEnd(DateTime.now());
                    saveProgress(currentTest, testList);

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
