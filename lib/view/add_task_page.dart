import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/bloc/add_task_bloc/add_task_bloc.dart';
import 'package:task_manager/repository/shared_preference.dart';
import 'package:task_manager/themes/colors.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDateController = TextEditingController();
  late String taskDate;

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  int selectedChipIndex = 0;

  final List<String> statusLabels = ["Not Started", "On Progress", "Completed"];

  @override
  void initState() {
    taskDate = DateFormat('yMMMd').format(DateTime.now());
    taskDateController.text = taskDate;
    super.initState();
  }

  void _updateStartTime(TimeOfDay newTime) {
    setState(() {
      _startTime = newTime;
    });
  }

  void _updateEndTime(TimeOfDay newTime) {
    setState(() {
      _endTime = newTime;
    });
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimePickerProvider(
      startTime: _startTime,
      endTime: _endTime,
      updateStartTime: _updateStartTime,
      updateEndTime: _updateEndTime,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          forceMaterialTransparency: true,
          title: Text(
            "Add Task",
            style: TextStyle(fontFamily: "medium", color: Colors.black),
          ),
        ),
        body: BlocListener<AddTaskBloc, AddTaskState>(
          listener: (context, state) {
            if (state is TaskAddedSuccessState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  content: Text(
                    "Task Added",
                    style: TextStyle(fontFamily: "medium"),
                  ),
                ),
              );
            }

            if (state is MissingTaskNameState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(
                    "Please enter task name",
                    style: TextStyle(fontFamily: "medium"),
                  ),
                ),
              );
            }

            if (state is StartDateEqualToEndDateState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(
                    "Start time and end time cannot be same",
                    style: TextStyle(fontFamily: "medium"),
                  ),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              spacing: 25,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "medium",
                    color: greyVarient,
                  ),
                ),

                TextField(
                  controller: taskNameController,
                  style: TextStyle(fontFamily: "medium", color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter Task Name",
                    hintStyle: TextStyle(
                      fontFamily: "medium",
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dividerColor),
                    ),
                  ),
                ),

                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "medium",
                    color: greyVarient,
                  ),
                ),

                TextField(
                  controller: taskDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        taskDate = DateFormat('yMMMd').format(pickedDate);
                        taskDateController.text = taskDate;
                      });
                    }
                  },
                  style: TextStyle(fontFamily: "medium", color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: dividerColor),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Time",
                          style: TextStyle(
                            fontFamily: "medium",
                            color: greyVarient,
                            fontSize: 16,
                          ),
                        ),

                        TimePickerTextField(isStart: true),
                      ],
                    ),
                    Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Time",
                          style: TextStyle(
                            fontFamily: "medium",
                            color: greyVarient,
                            fontSize: 16,
                          ),
                        ),

                        TimePickerTextField(isStart: false),
                      ],
                    ),
                  ],
                ),

                Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontFamily: "medium",
                        fontSize: 16,
                        color: greyVarient,
                      ),
                    ),

                    SizedBox(
                      width: double.maxFinite,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(statusLabels.length, (
                              int index,
                            ) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: ChoiceChip(
                                  side: BorderSide(
                                    color:
                                        selectedChipIndex == index
                                            ? selectedBottomNavBarColor
                                            : dividerColor,
                                  ),
                                  label: Text(
                                    statusLabels[index],
                                    style: TextStyle(
                                      fontFamily: "semibold",
                                      fontSize: 16,
                                      color:
                                          selectedChipIndex == index
                                              ? Colors.black
                                              : greyVarient,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  selected: selectedChipIndex == index,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      selectedChipIndex = index;
                                    });
                                  },
                                  color: WidgetStateColor.resolveWith((
                                    context,
                                  ) {
                                    return Colors.white;
                                  }),
                                  showCheckmark: false,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedBottomNavBarColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () async {

                        String formatTimeOfDay(
                          BuildContext context,
                          TimeOfDay time,
                        ) {
                          final localizations = MaterialLocalizations.of(
                            context,
                          );
                          return localizations.formatTimeOfDay(time);
                        }

                        Map<String, String> taskData = {
                          "uid":
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          "start": formatTimeOfDay(context, _startTime),
                          "end": formatTimeOfDay(context, _endTime),
                          "date": taskDate,
                          "taskName": taskNameController.text,
                          "status": statusLabels[selectedChipIndex],
                        };
                        BlocProvider.of<AddTaskBloc>(
                          context,
                        ).add(AddRRespectiveTaskEvent(task: taskData));
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontFamily: "medium",
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimePickerTextField extends StatelessWidget {
  final bool isStart;

  const TimePickerTextField({super.key, required this.isStart});

  @override
  Widget build(BuildContext context) {
    final provider = TimePickerProvider.of(context);
    final selectedTime = isStart ? provider.startTime : provider.endTime;
    final formattedTime = selectedTime.format(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: TextField(
        controller: TextEditingController(text: formattedTime),
        readOnly: true,
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: selectedTime,
          );
          if (picked != null) {
            if (isStart) {
              provider.updateStartTime(picked);
            } else {
              if (_isStartBeforeEnd(provider.startTime, picked)) {
                provider.updateEndTime(picked);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text(
                      "End time must be after start time",
                      style: TextStyle(fontFamily: "medium"),
                    ),
                  ),
                );
              }
            }
          }
        },
        style: TextStyle(fontFamily: "medium", color: Colors.black),
        decoration: InputDecoration(
          hintText: "Select Time",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  bool _isStartBeforeEnd(TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      end.hour,
      end.minute,
    );
    return startDateTime.isBefore(endDateTime);
  }
}

class TimePickerProvider extends InheritedWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final void Function(TimeOfDay) updateStartTime;
  final void Function(TimeOfDay) updateEndTime;

  const TimePickerProvider({
    required this.startTime,
    required this.endTime,
    required this.updateStartTime,
    required this.updateEndTime,
    required super.child,
    super.key,
  });

  static TimePickerProvider of(BuildContext context) {
    final TimePickerProvider? result =
        context.dependOnInheritedWidgetOfExactType<TimePickerProvider>();
    assert(result != null, 'No TimePickerProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TimePickerProvider oldWidget) {
    return startTime != oldWidget.startTime || endTime != oldWidget.endTime;
  }
}
