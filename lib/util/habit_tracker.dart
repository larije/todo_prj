import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_prj/habit_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_prj/hidden_drawer.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  // habit details
  List habitList = [
    // [ habitName , habitActive, timeSpentSoFar in seconds, goalTime in minutes ]
    ['Exercise', false, 0, 10],
    ['Read', false, 0, 10],
    ['Meditate', false, 0, 10],
    ['Code', false, 0, 10],
  ];

  // reference the box
  final _myBox = Hive.box('mybox');

  @override
  void initState() {
    if (_myBox.isNotEmpty) {
      loadData();
    }
    super.initState();
  }

  // write data
  void writeData(int index) {
    // habit names
    String habitName1 = habitList[0][0];
    String habitName2 = habitList[1][0];
    String habitName3 = habitList[2][0];
    String habitName4 = habitList[3][0];

    // time spent
    int habitTimeSpent1 = habitList[0][2];
    int habitTimeSpent2 = habitList[1][2];
    int habitTimeSpent3 = habitList[2][2];
    int habitTimeSpent4 = habitList[3][2];

    // time goal
    int habitTimeGoal1 = habitList[0][3];
    int habitTimeGoal2 = habitList[1][3];
    int habitTimeGoal3 = habitList[2][3];
    int habitTimeGoal4 = habitList[3][3];

    // [ (habitname, timespent, timegoal) .. ]
    List entireHabitSummary = [
      [habitName1, habitTimeSpent1, habitTimeGoal1],
      [habitName2, habitTimeSpent2, habitTimeGoal2],
      [habitName3, habitTimeSpent3, habitTimeGoal3],
      [habitName4, habitTimeSpent4, habitTimeGoal4],
    ];

    _myBox.put(currentDateFormatted(), entireHabitSummary);
  }

  // read data
  loadData() async {
    // load habit name
    String existingHabit1Name = await _myBox.get(currentDateFormatted())[0][0];
    String existingHabit2Name = await _myBox.get(currentDateFormatted())[1][0];
    String existingHabit3Name = await _myBox.get(currentDateFormatted())[2][0];
    String existingHabit4Name = await _myBox.get(currentDateFormatted())[3][0];

    // load habit time spent
    int existingHabit1TimeSpent =
        await _myBox.get(currentDateFormatted())[0][1];
    int existingHabit2TimeSpent =
        await _myBox.get(currentDateFormatted())[1][1];
    int existingHabit3TimeSpent =
        await _myBox.get(currentDateFormatted())[2][1];
    int existingHabit4TimeSpent =
        await _myBox.get(currentDateFormatted())[3][1];

    // load habit time goal
    int existingHabit1TimeGoal = await _myBox.get(currentDateFormatted())[0][2];
    int existingHabit2TimeGoal = await _myBox.get(currentDateFormatted())[1][2];
    int existingHabit3TimeGoal = await _myBox.get(currentDateFormatted())[2][2];
    int existingHabit4TimeGoal = await _myBox.get(currentDateFormatted())[3][2];

    // update habit name
    habitList[0][0] = existingHabit1Name;
    habitList[1][0] = existingHabit2Name;
    habitList[2][0] = existingHabit3Name;
    habitList[3][0] = existingHabit4Name;

    // update habit time spent
    habitList[0][2] = existingHabit1TimeSpent;
    habitList[1][2] = existingHabit2TimeSpent;
    habitList[2][2] = existingHabit3TimeSpent;
    habitList[3][2] = existingHabit4TimeSpent;

    // update habit time goals
    habitList[0][3] = existingHabit1TimeGoal;
    habitList[1][3] = existingHabit2TimeGoal;
    habitList[2][3] = existingHabit3TimeGoal;
    habitList[3][3] = existingHabit4TimeGoal;
  }

  String currentDateFormatted() {
    // get todays date
    var currentDate = DateTime.now();

    // year in the format yyyy
    String year = currentDate.year.toString();

    // month in the format mm
    String month = currentDate.month.toString();
    if (month.length == 1) {
      month = '0' + month;
    }

    // day in the format dd
    String day = currentDate.day.toString();
    if (day.length == 1) {
      day = '0' + day;
    }

    // final format
    String yyyymmdd = year + month + day;

    return yyyymmdd;
  }

  int calculatePercentage(double numerator, double denominator) {
    return ((numerator / denominator) * 100).round();
  }

  // start habit
  void startHabit(int habitIndex) {
    // get the time that it started
    var startTime = DateTime.now();
    int elapsedTimeSoFar = habitList[habitIndex][2];

    Timer.periodic(
      // i made this 100 millisecond instead of 1 second.
      // 1 second meant it had to wait until the full next second until it cancelled the timerrf xcvxcdzvxdvf edf sefsefs
      // the current algorithm doesn't rely on the timer anyway as long as duration is =< 1 sec
      const Duration(milliseconds: 300),
      (timer) {
        setState(() {
          // check whether user has stopped
          if (habitList[habitIndex][1] == false) {
            // update data locally
            writeData(habitIndex);

            timer.cancel();
          }

          // calculate and update time elapsed on screen
          var currentTime = DateTime.now();
          habitList[habitIndex][2] = elapsedTimeSoFar +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      },
    );
  }

  // save habit
  void saveHabit(int index) {
    setState(() {
      // update the habit name
      habitList[index][0] = _habitNameController.text;

      // update the goal time
      habitList[index][3] = _wheelMinuteController.selectedItem;
    });

    writeData(index);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HiddenDrawer()));
    //Navigator.pop(context);
  }

  // text style variables
  var whiteTextStyle = const TextStyle(color: Colors.white);

  // controllers
  // let's initialize these controllers later when we know which habit index we're looking at
  late TextEditingController _habitNameController;
  late FixedExtentScrollController _wheelHourController;
  late FixedExtentScrollController _wheelMinuteController;

  // open habit settings
  void openHabitSettings(int index) {
    // initialize controllers
    _wheelMinuteController =
        FixedExtentScrollController(initialItem: habitList[index][3]);
    _habitNameController = TextEditingController(text: habitList[index][0]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          content: SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _habitNameController,
                      style: whiteTextStyle,
                      maxLength: 16,
                      decoration: InputDecoration(
                        hintText: habitList[index][0],
                        hintStyle: whiteTextStyle,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Daily goal time for this habit',
                      style: whiteTextStyle,
                    ),
                  ],
                ),
                SizedBox(
                    height: 160,
                    child: Stack(
                      children: [
                        Container(
                          alignment: const Alignment(0, 0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 37, 37, 37),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // scroll wheel for hours
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: SizedBox(
                                width: 50,
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 30,
                                  perspective: 0.005,
                                  diameterRatio: 1.2,
                                  physics: const FixedExtentScrollPhysics(),
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: 24,
                                    builder: (context, index) {
                                      return Text(
                                        index.toString(),
                                        style: const TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // hour
                            Text(
                              'hrs',
                              style: whiteTextStyle,
                            ),

                            // scroll wheel for minutes
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: SizedBox(
                                width: 50,
                                child: ListWheelScrollView.useDelegate(
                                  controller: _wheelMinuteController,
                                  itemExtent: 30,
                                  perspective: 0.005,
                                  diameterRatio: 1.2,
                                  physics: const FixedExtentScrollPhysics(),
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: 60,
                                    builder: (context, index) {
                                      return Text(
                                        index.toString(),
                                        style: const TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // mins
                            Text(
                              'mins',
                              style: whiteTextStyle,
                            ),
                          ],
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        saveHabit(index);
                      },
                      child: Text(
                        'S A V E',
                        style: whiteTextStyle,
                      ),
                      color: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // temporary dates to display
  List<String> dates = [
    '20220704',
    '20220705',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[900],
      //   title: Text('  Consistency is key.'),
      //   centerTitle: false,
      // ),
      body: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: habitList.length,
        itemBuilder: ((context, index) {
          return HabitTile(
            habitName: habitList[index][0],
            currentTimeSpent: habitList[index][2],
            goalTime: habitList[index][3],
            onTap: () {
              setState(() {
                // change the habit active status
                habitList[index][1] = !habitList[index][1];
              });
              if (habitList[index][1] == true) {
                // start habit
                startHabit(index);
              } else {
                // stop habit
              }
            },
            habitStarted: habitList[index][1],
            onSettingsTap: () {
              openHabitSettings(index);
            },
          );
        }),
      ),
    );
  }
}
