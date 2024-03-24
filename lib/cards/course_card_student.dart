import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import '../home_pages/CourseHomeStudent.dart';
import 'course_card.dart';

class CourseCardStudent extends CourseCard {
  String courseUid;
  String studentUid;
  CourseCardStudent({Key? key,required this.courseUid, required this.studentUid}) : super(key: key,courseUid: courseUid,);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> CourseStudent(courseUid: courseUid))
        );
      },
      onLongPress: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Create an AlertDialog widget and set its properties
              return AlertDialog(
                title: const Text('Do You Really Want To Leave This Course?'),
                content: const Text('You Can Choose To Rejoin This Course Later'),
                actions: [
                  // Add a TextButton widget that deletes the course when pressed
                  TextButton(
                    onPressed: () {
                      DatabaseServicesCourses().removeStudentFromCourse(courseUid, studentUid);
                      DatabaseServicesStudent().removeCourseFromStudent(studentUid, courseUid);

                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                    // Change the color of the button to red
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                  // Add a TextButton widget that cancels the action when pressed
                  TextButton(
                    onPressed: () {

                      // Close the dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );


      },
      child: super.build(context),

    );
  }
}
