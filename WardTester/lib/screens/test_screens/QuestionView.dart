import 'package:flutter/material.dart';
import '../test_screens/question_screens/RFRQ_Widget.dart';
import '../test_screens/question_screens/MCQ_Widget.dart';
import '../test_screens/question_screens/FRQ_Widget.dart';
import '../../main.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({Key? key}) : super(key: key);

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  var questionType;

  @override
  Widget build(BuildContext context) {
    print(currentQ.getType());
    setState(() {
      questionType = currentQ.getType();
    });
    return Container(
      child: SingleChildScrollView(
          child: questionType == 0
              ? MCQ_Widget()
              : questionType == 1
                  ? FRQ_Widget()
                  : RFRQ_Widget()),
      alignment: Alignment.topCenter,
    );
  }
}
