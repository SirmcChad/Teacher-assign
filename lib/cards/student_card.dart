import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/home_pages/CourseHomeTeacher.dart';
import 'package:teacher_assign/services/database_services_student.dart';

class StudentCard extends StatelessWidget {
  final String studentUid;
  const StudentCard({super.key, required this.studentUid});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            future: DatabaseServicesStudent().studentCollection.doc(studentUid).get(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return ListTile(title: Text('waiting...'),);
              }
              else if (snapshot.hasData){
                Map<String, dynamic>? studentData = snapshot.data!.data()! as Map<String, dynamic>?;

                String studentName = studentData?['name'];
                return ListTile(
                  title: Text(
                    studentName,
                    // Add some style to the text
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              else{
                return ListTile(title: Text('some error occured'));
              }

            },

          ),
        ),
      ),
    );
  }
}
