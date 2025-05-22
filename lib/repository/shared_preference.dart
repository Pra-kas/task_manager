import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreference? _instance;
  static SharedPreferences? _prefs;

  SharedPreference._internal();

  static Future<SharedPreference> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreference._internal();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  String getCurrentDate(){
    return DateFormat("MMMM, d").format(DateTime.now());
  }

  Future<List<String>> getTaskFromsharedPreference(String date) async {
    try {
      List<String> taskList = _prefs?.getStringList(date)?? [];
      return taskList;
    } catch (e) {
      print("Error getting task from shared preference: $e");
      return [];
    }
  }

  void addTaskTosharedPreference(Map<String, String> data) async {
    try {
      List<String> taskList = await getTaskFromsharedPreference(data["date"] ?? getCurrentDate());
      taskList.add(jsonEncode(data));
      print("the value is $taskList");
      _prefs!.setStringList(data["date"] ?? getCurrentDate(), taskList);
    } catch (e) {
      print("Error adding task to shared preference: $e");
    }
  }
}
