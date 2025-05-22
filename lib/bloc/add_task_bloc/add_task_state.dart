part of 'add_task_bloc.dart';

@immutable
sealed class AddTaskState {}

final class AddTaskInitial extends AddTaskState {}

class TaskAddedSuccessState extends AddTaskState{}

class MissingTaskNameState extends AddTaskState{}

class StartDateEqualToEndDateState extends AddTaskState{}
