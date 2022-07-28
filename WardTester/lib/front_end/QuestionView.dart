import 'package:flutter/material.dart';
import 'package:trying/front_end/FRQ.dart';
import 'MultipleChoice.dart';
import 'FRQ.dart';
import 'RandomFRQ.dart';
import '../main.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({Key? key}) : super(key: key);

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  var t;

  @override
  Widget build(BuildContext context) {
    print(currentQ.getType());
    setState(() {
      t = currentQ.getType();
    });
    return Container(
      child: SingleChildScrollView(
          child: t == 0
              ? MultipleChoice()
              : t == 1
                  ? FRQ()
                  : RandomFRQ()),
      alignment: Alignment.topCenter,
    );
  }
}
