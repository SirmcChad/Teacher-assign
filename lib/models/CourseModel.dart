import 'StudentModel.dart';

class CourseModel {
  String uid;
  List<StudentModel> students;
  String courseSubject;
  int numberOfTasks;

  CourseModel({required this.uid, required this.students, required this.courseSubject, required this.numberOfTasks});
}