import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../back_end/utils.dart';
import '../QuestionPage.dart';
import '../../HomePage.dart';

class RFRQ_Widget extends StatefulWidget {
  const RFRQ_Widget({Key? key}) : super(key: key);

  @override
  State<RFRQ_Widget> createState() => _RFRQ_WidgetState();
}

class _RFRQ_WidgetState extends State<RFRQ_Widget> {
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
