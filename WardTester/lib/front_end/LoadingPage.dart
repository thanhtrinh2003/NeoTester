// import 'package:flutter/material.dart';
// import '../main.dart';
// import 'SelectCoursePage.dart';
// import 'ProgressPage.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../back_end/utilities.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future:
//             updateTestFile(), // the function to get your data from firebase or firestore
//         builder: (BuildContext context, AsyncSnapshot snap) {
//           if (snap.data == null) {
//             return Scaffold(
//               backgroundColor: Colors.blue.shade600,
//               body: Center(child: SpinKitCubeGrid),
//             );
//           } else {
//             //return the widget that you want to display after loading
//           }
//         });
//   }
// }
