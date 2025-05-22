import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/repository/shared_preference.dart';
import 'package:task_manager/view/todo_page.dart';

part 'todo_bloc_event.dart';
part 'todo_bloc_state.dart';

class TodoBloc extends Bloc<TodoBlocEvent, TodoBlocState> {
  List<Map<String,String>> tasks = [];
  TodoBloc() : super(TodoBlocInitial()) {
    on<GetRespectiveTaskEvent>(getRespectiveTaskEvent);
    on<MarkAsCompleteRespectiveTask>(markAsCompleteRespectiveTask);
  }

  Future<void> getTasksFromsharedPreference(String date) async {
    final prefs = await SharedPreference.getInstance();
    tasks.clear();
    List<String> tempTask = await prefs.getTaskFromsharedPreference(date);
    if (tempTask.isEmpty) {
        tasks = [];
      return;
    }
    for (var value in tempTask) {
      Map<String, dynamic> decoded = jsonDecode(value);
      Map<String, String> task = decoded.map(
        (key, val) => MapEntry(key, val.toString()),
      );
      tasks.add(task);
    }
    tasks = tasks;
    print("Success $tasks");
  }

  FutureOr<void> markAsCompleteRespectiveTask(MarkAsCompleteRespectiveTask event, Emitter<TodoBlocState> emit){
    emit(MarkAsCompletedTaskState(taskName: event.taskName));
  }

  FutureOr<void> getRespectiveTaskEvent(GetRespectiveTaskEvent event, Emitter<TodoBlocState> emit) async{
    emit(GetRespectiveTaskeventFetchingState());
    try{
        getTasksFromsharedPreference(event.date);
        emit(GetRespectiveTaskeventSuccessState(tasks: tasks));
    }
    catch(e){
      emit(GetRespectiveTaskeventFailureState(error: e.toString()));
    }
  }
}
