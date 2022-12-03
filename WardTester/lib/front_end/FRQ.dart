import 'package:flutter/material.dart';
import '../back_end/utils.dart';
import '../main.dart';
import 'QuestionPage.dart';
import 'HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../back_end/Test.dart';

class FRQ extends StatefulWidget {
  const FRQ({Key? key}) : super(key: key);

  @override
  State<FRQ> createState() => _FRQState();
}

class _FRQState extends State<FRQ> {
  List<TextEditingController>? textListController = List.generate(
      currentQ.getAnswer().length, (index) => TextEditingController());

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
          itemCount: currentQ.getAnswer().length,
          itemBuilder: (BuildContext context, int index) {
            return TextField(
                autofocus: true,
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
                  style: TextStyle(fontSize: 14, color: Colors.black))
            ])),
        Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () async {
                  if (!hasSubmitted) {
                    setState(() {
                      submitPressed(currentQ.isCorrect(textListController));
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
