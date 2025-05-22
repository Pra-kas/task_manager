part of 'add_task_bloc.dart';

@immutable
sealed class AddTaskEvent {}

class AddRRespectiveTaskEvent extends AddTaskEvent{
  final Map<String,String> task;
  AddRRespectiveTaskEvent({required this.task});
}