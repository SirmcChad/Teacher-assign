import 'package:flutter/material.dart';

class CourseStudent extends StatefulWidget {
  const CourseStudent({super.key});

  @override
  State<CourseStudent> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudent> {
  @override
  Widget build(BuildContext context) {
    final String courseUid = ModalRoute.of(context)!.settings.arguments as String;
    return const Placeholder();
  }
}
