part of 'todo_bloc.dart';

@immutable
sealed class TodoBlocEvent {}

class GetRespectiveTaskEvent extends TodoBlocEvent {
  final String date;
  GetRespectiveTaskEvent({required this.date});
}

class MarkAsCompleteRespectiveTask extends TodoBlocEvent{
  final String taskName;
  MarkAsCompleteRespectiveTask({required this.taskName});
}
