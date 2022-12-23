import 'package:todo_prj/util/habit_tracker.dart';
import 'package:todo_prj/util/home_page.dart';
import 'package:todo_prj/util/to_do.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 23,
    color: Color.fromARGB(255, 255, 251, 0),
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'ToDo List',
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.yellowAccent,
          ),
          ToDopage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'ToDo Tracker',
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.yellowAccent,
          ),
          HabitTrackerPage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Color.fromARGB(255, 0, 0, 0),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 48,
      contentCornerRadius: 20,
      enableCornerAnimation: true,
    );
  }
}
