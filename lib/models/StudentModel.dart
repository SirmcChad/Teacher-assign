import 'CourseModel.dart';

class StudentModel {
  String uid;
  String name;
  List<CourseModel> courses;

  StudentModel({required this.uid,required this.name , required this.courses});

}