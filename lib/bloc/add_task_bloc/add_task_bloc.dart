import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/repository/shared_preference.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(AddTaskInitial()) {
    on<AddRRespectiveTaskEvent>(addRRespectiveTaskEvent);
  }

  Future<bool> addTaskTosharedPreference(Map<String,String> task) async {
    final prefs = await SharedPreference.getInstance();
    String start = task['start'] ?? "";
    String end = task['end'] ?? "";
    if(start.contains("PM")){
      List<String> startTime = start.split(":");
      int hour = int.parse(startTime[0]) + 12;
      String newStart = "$hour:${startTime[1]}";
      task['start'] = newStart;
    }
    if(end.contains("PM")){
      List<String> endTime = end.split(":");
      int hour = int.parse(endTime[0]) + 12;
      String newEnd = "$hour:${endTime[1]}";
      task['end'] = newEnd;
    }
    try{
      prefs.addTaskTosharedPreference(task);
      return true;
    } 
    catch(e){
      print("Error adding task to shared preference: $e");
      return false;
    }
  }

  FutureOr<void>addRRespectiveTaskEvent(AddRRespectiveTaskEvent event, Emitter<AddTaskState> emit)async{
    Map<String,String> task = event.task;
    if(task['taskName'] == null || task['taskName']!.isEmpty){
      emit(MissingTaskNameState());
    }else if(task['start'] == task['end']){
      print("Start ${task["start"]}");
      print("End ${task["end"]}");
      emit(StartDateEqualToEndDateState());
    }else{
      bool isStored = await addTaskTosharedPreference(task);
      if(isStored) emit(TaskAddedSuccessState());
    }
  }
}
