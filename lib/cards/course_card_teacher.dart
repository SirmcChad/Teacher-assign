import 'package:flutter/material.dart';
import 'package:teacher_assign/home_pages/CourseHomeTeacher.dart';
import 'package:teacher_assign/services/database_services_teacher.dart';
import 'course_card.dart';

class CourseCardTeacher extends CourseCard {
  String courseUid;
  String teacherUid;
  CourseCardTeacher({Key? key,required this.courseUid, required this.teacherUid}) : super(key: key,courseUid: courseUid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> CourseTeacher(courseUid: courseUid))
        );
      },
      onLongPress: (){

        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Create an AlertDialog widget and set its properties
            return AlertDialog(
              title: const Text('Do You Really Want To Delete This Course?'),
              content: const Text('This Action Cannot Be Undone.'),
              actions: [
                // Add a TextButton widget that deletes the course when pressed
                TextButton(
                  onPressed: () {
                    DatabaseServicesTeacher().removeCourse(teacherUid, courseUid);

                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                  // Change the color of the button to red
                  style: TextButton.styleFrom(
                    primary: Colors.red,
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
