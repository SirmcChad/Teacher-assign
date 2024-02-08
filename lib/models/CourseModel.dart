import 'StudentModel.dart';

class CourseModel {
  String uid;
  List<dynamic> students;
  String courseSubject;
  int numberOfTasks;

  CourseModel({required this.uid, required this.students, required this.courseSubject, required this.numberOfTasks});

  Map<String,dynamic> toJSON(){
    return {
      'uid': uid,
      'students': students,
      'name': courseSubject,
      'tasks': numberOfTasks
    };
  }
  static CourseModel fromJson(Map<String,dynamic> json){
    return CourseModel(uid: json['uid'], students: json['students'], courseSubject: json['name'], numberOfTasks: json['tasks']);

  }
}