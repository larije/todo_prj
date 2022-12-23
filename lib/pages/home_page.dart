import 'package:flutter/material.dart';
import 'package:todo_prj/hidden_drawer.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HiddenDrawer(),
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}
