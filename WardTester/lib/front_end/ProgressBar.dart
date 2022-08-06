import 'package:flutter/material.dart';
import '../main.dart';
import '../back_end/utilities.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text:
                    "Total Number of Questions: " + currentTest.getTestLength(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ]),
      ),
      RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "Number of Attempts: " + currentTest.getTotalAttempt(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ]),
      ),
      RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "Number of Correct Questions: " +
                    currentTest.getTotalCorrect(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ]),
        // Padding(
        //           padding: EdgeInsets.all(15.0),
        //           child: new CircularPercentIndicator(
        //             radius: 60.0,
        //             lineWidth: 5.0,
        //             percent: 1.0,
        //             center: new Text("100%"),
        //             progressColor: Colors.green,
        //           ),
        //         ),
      ),
    ]);
  }
}
