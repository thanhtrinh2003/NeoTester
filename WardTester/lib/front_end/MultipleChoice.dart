import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/back_end.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';

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
                      answerDisplay =
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
                  text: answerDisplay,
                  style: TextStyle(fontSize: 12, color: Colors.black))
            ])),
        Container(
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () => {
                if (stateButton == 1)
                  {
                    answerDisplay = checkMultipleChoice(currentQ.getChoice(),
                        studentChoice, currentQ.getAnswer()),
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
                    })
                  }
                else
                  {
                    cur = cur + 1,
                    answerDisplay = "",
                    buttonQuestionText = "Submit",
                    stateButton = -stateButton,
                    if (questionOrder.isNotEmpty)
                      {
                        currentQ =
                            getQuestionInfo(test_file, questionOrder.first),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionPage()))
                      }
                    else
                      {
                        cur = 0,
                        // we will change to
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomePage()))
                      }
                  }
              },
              child: Text(buttonQuestionText),
            ))
      ],
    );
  }
}
