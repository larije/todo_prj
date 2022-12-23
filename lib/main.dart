import 'package:flutter/material.dart';
//import 'package:todo_prj/hidden_drawer.dart';
import 'package:todo_prj/onboarding_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
      //home: const HiddenDrawer(),
      //theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
