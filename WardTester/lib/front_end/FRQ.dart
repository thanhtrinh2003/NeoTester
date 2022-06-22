import 'package:flutter/material.dart';
import '../back_end/back_end.dart';
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
                  answerDisplay =
                      checkAnswerFRQ(textListController, currentQ.getAnswer());
                  setState(() {
                    if (answerDisplay == "This is correct!") {
                      correctNum++;
                      questionOrder.removeFirst();
                    } else {
                      questionOrder.add(questionOrder.first);
                      questionOrder.removeFirst();
                    }
                    buttonQuestionText = "Next";
                    stateButton = -stateButton;
                  });
                } else {
                  cur = cur + 1;
                  buttonQuestionText = "Submit";
                  answerDisplay = "";
                  stateButton = -stateButton;
                  if (questionOrder.isNotEmpty) {
                    currentQ = getQuestionInfo(test_file, questionOrder.first);
                    if (currentQ.getImagePath() != "") {
                      currentQ.setImagePath(
                          '$appDocPath/Image/' + currentQ.getImagePath());
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage()));
                  } else {
                    cur = 0;
                    // we will change to home page
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
