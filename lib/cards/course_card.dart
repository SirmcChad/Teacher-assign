import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/home_pages/CourseHomeStudent.dart';
import 'package:teacher_assign/home_pages/CourseHomeTeacher.dart';
import 'package:teacher_assign/services/database_services_courses.dart';

class CourseCard extends StatelessWidget {
  String courseUid;
  bool isTeacher;
  CourseCard({Key? key,required this.courseUid, required this.isTeacher}) : super(key: key);

  void navigate(BuildContext context){
    if(isTeacher){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> CourseTeacher(courseUid: courseUid))
      );
    }

    else{
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> CourseStudent(courseUid: courseUid))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        navigate(context);

      },
      child: Card(
        // Add some margin to the card
        margin: const EdgeInsets.all(10),
        // Add some elevation to the card
        elevation: 5,
        // Add some shape to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // The rounded corners
        ),
        // Add some color to the card
        color: Colors.blue[100],
        child: Center(
          child: Padding(
            // Add some padding to the text
            padding: const EdgeInsets.all(15),
            child: FutureBuilder<DocumentSnapshot>(
              future: DatabaseServicesCourses().courseCollection.doc(courseUid).get(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return Text('waiting...');
                }
                else if (snapshot.hasData){
                  Map<String, dynamic>? courseData = snapshot.data!.data()! as Map<String, dynamic>?;

                  String courseName = courseData?['name'];
                  return Text(
                    courseName,
                    // Add some style to the text
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                else{
                  return Text('some error occured');
                }

              },

            ),
          ),
        ),
      ),
    );
  }
}

/*
Text(
              courseUid,
              // Add some style to the text
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
 */