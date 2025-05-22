part of 'todo_bloc.dart';

@immutable
sealed class TodoBlocState {}

final class TodoBlocInitial extends TodoBlocState {}

class GetRespectiveTaskeventFetchingState extends TodoBlocState {}

class GetRespectiveTaskeventSuccessState extends TodoBlocState {
  final List<Map<String, String>> tasks;
  GetRespectiveTaskeventSuccessState({required this.tasks});
}
class GetRespectiveTaskeventFailureState extends TodoBlocState {
  final String error;
  GetRespectiveTaskeventFailureState({required this.error});
}

class MarkAsCompletedTaskState extends TodoBlocState{
  final String taskName;
  MarkAsCompletedTaskState({required this.taskName});
}