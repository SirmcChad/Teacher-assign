import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services.dart';

class CourseCard extends StatelessWidget {
  String courseUid;
   CourseCard({Key? key,required this.courseUid}) : super(key: key);

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
            future: DatabaseServices().courseCollection.doc(courseUid).get(),
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