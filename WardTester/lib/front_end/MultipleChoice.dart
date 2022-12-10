import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/utils.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';

class MultipleChoice extends StatefulWidget {
  const MultipleChoice({Key? key}) : super(key: key);

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  var studentChoice;

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
                  style: TextStyle(fontSize: 19, color: Colors.black))
            ])),
        ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: currentQ.getChoice().length,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
                child: Text(currentQ.getChoice()[index]),
                style: ElevatedButton.styleFrom(primary: Color(0xFF2979FF)),
                onPressed: () => setState(() {
                      studentChoice = index;
                      resultDisplay =
                          "Selected Answer: " + currentQ.getChoice()[index];
                    }));
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
                  style: TextStyle(fontSize: 14, color: Colors.black))
            ])),
        Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () async {
                  if (!hasSubmitted) {
                    setState(() {
                      submitPressed(currentQ.isCorrect(studentChoice));
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
      ],
    );
  }
}
