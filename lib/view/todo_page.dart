import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/repository/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/themes/colors.dart';
import 'dart:math' as math;

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String selectedDate = DateFormat("MMMM d, yyyy").format(DateTime.now());
  String calculateDayandMonth() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM, d').format(now);
    return formattedDate;
  }

  void updateSelectedDate(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: SelectedDateProvider(
        selectedDate: selectedDate,
        onDateSelected: (String date) {
          updateSelectedDate(date);
        },
        child: Scaffold(
          backgroundColor: todoBackGround,
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  child: SvgPicture.asset('assets/icons/edit_task.svg'),
                ),
              ),
            ],
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            leading: BackButton(),
            centerTitle: true,
            title: Text("Today Task", style: TextStyle(fontFamily: "bold")),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/homepage_container.svg',
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${calculateDayandMonth()} ✍',
                                  style: TextStyle(
                                    fontFamily: "bold",
                                    fontSize: 35,
                                  ),
                                ),
                                Text(
                                  "15 tasks today",
                                  style: TextStyle(
                                    fontFamily: "regular",
                                    color: greyVarient,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            "assets/icons/todo_calender.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: DateWidget()),
                SliverToBoxAdapter(child: Divider(color: dividerColor)),
                SliverToBoxAdapter(child: TimeLine()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late List<DateTime> allDates;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final endOfMonth = DateTime(today.year, today.month + 1, 0);

    allDates = List.generate(
      endOfMonth.difference(today).inDays + 1,
      (index) => today.add(Duration(days: index)),
    );

    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allDates.length,
        itemBuilder: (context, index) {
          final date = allDates[index];
          final isSelected = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  SelectedDateProvider.of(
                    context,
                  )!.onDateSelected(DateFormat("MMMM d, yyyy").format(date));
                });
                BlocProvider.of<TodoBloc>(context).add(
                  GetRespectiveTaskEvent(
                    date: SelectedDateProvider.of(context)!.selectedDate,
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.18,
                decoration: BoxDecoration(
                  color: isSelected ? selectedBottomNavBarColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("d").format(date),
                      style: TextStyle(
                        fontFamily: "medium",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : greyVarient,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      daysOfWeek[date.weekday % 7],
                      style: TextStyle(
                        fontFamily: "medium",
                        fontSize: 12,
                        color: isSelected ? Colors.white : greyVarient,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class TimeLine extends StatefulWidget {
  TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        BlocProvider.of<TodoBloc>(context, listen: false).add(
          GetRespectiveTaskEvent(
            date: SelectedDateProvider.of(context)!.selectedDate,
          ),
        );
      });
    } catch (e) {
      print("Error in depen: $e");
    }
  }

  List<Map<String, String>> tasks = [];
  final List<String> timeLines = [
    "12 AM",
    "01 AM",
    "02 AM",
    "03 AM",
    "04 AM",
    "05 AM",
    "06 AM",
    "07 AM",
    "08 AM",
    "09 AM",
    "10 AM",
    "11 AM",
    "12 PM",
    "01 PM",
    "02 PM",
    "03 PM",
    "04 PM",
    "05 PM",
    "06 PM",
    "07 PM",
    "08 PM",
    "09 PM",
    "10 PM",
    "11 PM",
  ];

  double timeLineHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.12;

  double parseTime(String time) {
    final parts = time.split(" ");
    final timeParts = parts[0].split(":").map(int.parse).toList();
    int hour = timeParts[0];
    int minute = timeParts.length > 1 ? timeParts[1] : 0;
    if (parts[1].toLowerCase() == "PM" && hour != 12) hour += 12;
    if (parts[1].toLowerCase() == "AM" && hour == 12) hour = 0;
    return hour + (minute / 60.0);
  }

  @override
  Widget build(BuildContext context) {
    final timeHeight = timeLineHeight(context);
    return BlocConsumer<TodoBloc, TodoBlocState>(
      listener: (context, state) {
        if (state is GetRespectiveTaskeventSuccessState) {
          tasks = state.tasks;
        }
      },
      builder: (context, state) {
        if (state is GetRespectiveTaskeventFetchingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          height: timeHeight * timeLines.length,
          child: Stack(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timeLines.length,
                itemBuilder: (context, index) {
                  return TimeLineWidget(timeLine: timeLines[index]);
                },
              ),

              ...tasks.map((task) {
                double startHour = parseTime(task["start"]!);
                double endHour = parseTime(task["end"]!);
                double duration = (endHour - startHour).abs();
                double calculatedHeight = timeHeight * (duration.abs());
                double minHeight = 50;
                print("Start: $startHour, End: $endHour, Duration: $duration, CalculatedHeight $calculatedHeight");

                if (state is MarkAsCompletedTaskState &&
                    state.taskName == task["taskName"]) {
                  print("Actually it is emitting");

                  double startHour = parseTime(task["start"]!);
                  double endHour = parseTime(task["end"]!);
                  double duration = endHour - startHour;
                  double calculatedHeight = timeHeight * (duration.abs());
                  double minHeight = 50;

                  return Positioned(
                    top: timeHeight * startHour,
                    left: MediaQuery.of(context).size.width * 0.3,
                    right: 0,
                    child: AnimatedMarkAsCompletedWidget(child: 
                      taskDisplayWidget(
                        task: task,
                        calculatedHeight: calculatedHeight,
                        minHeight: minHeight,
                      ),
                    ),
                  );
                }

                return Positioned(
                  top: timeHeight * startHour,
                  left: MediaQuery.of(context).size.width * 0.3,
                  right: 0,
                  child: GestureDetector(
                    onLongPress: () {
                      longPressLogicOfTask(task["taskName"] ?? "", context);
                    },
                    onTap: () {
                      if (calculatedHeight < minHeight) {
                        bottomSheetForLessHeight(context, task);
                      }
                    },
                    child: taskDisplayWidget(
                      task: task,
                      calculatedHeight: calculatedHeight,
                      minHeight: minHeight,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> bottomSheetForLessHeight(
    BuildContext context,
    Map<String, String> task,
  ) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task["taskName"] ?? "",
                    style: const TextStyle(fontSize: 18, fontFamily: "medium"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${task["start"]} - ${task["end"]}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "medium",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<dynamic> longPressLogicOfTask(String taskName, BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 30,
            children: [
              GestureDetector(
                onTap: () {
                  try {
                    BlocProvider.of<TodoBloc>(
                      context,
                    ).add(MarkAsCompleteRespectiveTask(taskName: taskName));
                  } catch (e) {
                    print("Error in long press: $e");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_box, color: Colors.green),
                    title: const Text(
                      'Mark as Completed',
                      style: TextStyle(fontFamily: "medium"),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue),
                  title: const Text(
                    'Edit Task',
                    style: TextStyle(fontFamily: "medium"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class taskDisplayWidget extends StatelessWidget {
  const taskDisplayWidget({
    super.key,
    required this.calculatedHeight,
    required this.minHeight,
    required this.task,
  });

  final double calculatedHeight;
  final Map<String, String> task;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: math.max(calculatedHeight, minHeight),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: taskBackGroundColor[math.Random().nextInt(1000) % 3],
        borderRadius: BorderRadius.circular(18),
      ),
      child:
          calculatedHeight < minHeight
              ? Icon(Icons.more_horiz, color: Colors.white)
              : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task["taskName"] ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: "medium", color: Colors.white),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      maxLines: null,
                      "${task["start"]} - ${task["end"]}",
                      style: TextStyle(
                        fontFamily: "regular",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({super.key, required this.timeLine});

  final String timeLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
      ),
      height: MediaQuery.of(context).size.height * 0.12,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          timeLine,
          style: TextStyle(fontSize: 16, fontFamily: "semibold"),
        ),
      ),
    );
  }
}

class SelectedDateProvider extends InheritedWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  const SelectedDateProvider({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required super.child,
  });

  static SelectedDateProvider? of(BuildContext context) {
    final value =
        context.dependOnInheritedWidgetOfExactType<SelectedDateProvider>();
    assert(value != null, "No SelectedDateProvider found in context");
    return value;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class AnimatedMarkAsCompletedWidget extends StatefulWidget {
  final Widget child;
  const AnimatedMarkAsCompletedWidget({super.key, required this.child});

  @override
  State<AnimatedMarkAsCompletedWidget> createState() =>
      _AnimatedMarkAsCompletedWidgetState();
}

class _AnimatedMarkAsCompletedWidgetState
    extends State<AnimatedMarkAsCompletedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);
    _controller.addListener(() {
      print("Value: ${_animation.value}");
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: _animation.value,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
      ],
    );
  }
}
