import 'package:flutter/material.dart';

class Course extends StatefulWidget {
  String courseUid;
  Course({Key? key,required this.courseUid}) : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}