import 'package:flutter/material.dart';
import 'package:trying/front_end/FRQ.dart';
import 'MultipleChoice.dart';
import 'FRQ.dart';
import 'RandomFRQ.dart';
import 'LoadingPage.dart';
import 'ReconnectPage.dart';
import 'HomePage.dart';
import '../main.dart';

class DirectionPage extends StatefulWidget {
  const DirectionPage({Key? key}) : super(key: key);

  @override
  State<DirectionPage> createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  @override
  Widget build(BuildContext context) {
    return initialPage == "ReconnectPage"
        ? ReconnectPage()
        : initialPage == "UpdatePage"
            ? LoadingPage()
            : HomePage();
  }
}
