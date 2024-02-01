import 'CourseModel.dart';

class TeacherModel {
  String uid;
  String name;
  List<CourseModel> courses;

  TeacherModel({required this.uid, required this.name,required this.courses});

}