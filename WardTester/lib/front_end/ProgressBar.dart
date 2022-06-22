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
                text: "Total Number of Questions: " + questionNum.toString(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ]),
      ),
      RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "Number of Finished Questions: " + cur.toString(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ]),
      ),
      RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "Number of Correct Questions: " + correctNum.toString(),
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
