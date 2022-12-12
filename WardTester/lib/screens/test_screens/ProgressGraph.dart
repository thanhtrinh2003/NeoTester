import 'package:flutter/material.dart';
import '../../main.dart';

class ProgressGraph extends StatefulWidget {
  const ProgressGraph({Key? key}) : super(key: key);

  @override
  State<ProgressGraph> createState() => _ProgressGraphState();
}

class _ProgressGraphState extends State<ProgressGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: "Progress",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ]),
              ),
              SizedBox(height: 80),
              CircularProgressIndicator(
                backgroundColor: Colors.grey.shade400,
                value: currentTest.getTotalCorrect() /
                    currentTest.getNumQuestion(),
                semanticsLabel: 'Linear progress indicator',
                strokeWidth: 120,
              ),
              SizedBox(height: 80),
              RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: "Total Number of Questions: " +
                            currentTest.getNumQuestion().toString(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    ]),
              ),
              RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: "Number of Attempts: " +
                            currentTest.getTotalAttempt().toString(),
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
                            currentTest.getTotalCorrect().toString(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ]),
              ),
            ])),
        alignment: Alignment.topCenter);
  }
}
