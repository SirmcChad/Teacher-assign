import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  String courseName;
   CourseCard({Key? key,required this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(courseName)
      ),
    );
  }
}
