class TaskModel {
  String taskName;
  String uid;
  String date;
  String startTime;
  String endtime;
  String status;
  TaskModel({
    required this.taskName,
    required this.uid,
    required this.date,
    required this.startTime,
    required this.endtime,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'uid': uid,
      'date': date,
      'startTime': startTime,
      'endtime': endtime,
      'status': status,
    };
  }

  TaskModel fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskName: json['taskName'],
      uid: json['uid'],
      date: json['date'],
      startTime: json['startTime'],
      endtime: json['endtime'],
      status: json['status'],
    );
  }
}
