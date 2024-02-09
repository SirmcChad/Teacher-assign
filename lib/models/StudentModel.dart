import 'CourseModel.dart';

class StudentModel {
  String uid;
  String name;
  List<String> courses;

  StudentModel({required this.uid,required this.name , required this.courses});

  Map<String,dynamic> toJSON(){
    return {
      'uid': uid,
      'courses': courses,
      'name': name,
    };
  }
  static StudentModel fromJson(Map<String,dynamic> json){
    return StudentModel(uid: json['uid'], courses: json['courses'], name: json['name']);

  }

}