import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/get_options.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services.dart';
import 'package:teacher_assign/shared/custom_loading.dart';

class CourseCard extends StatelessWidget {
  String courseUid;
   CourseCard({Key? key,required this.courseUid}) : super(key: key);

   Future<DocumentSnapshot> getName()async{
     final services = DatabaseServices();
     DocumentReference reference =  services.courseCollection.doc(courseUid);
     return reference.get();
   }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      future: getName(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }
        else if (snapshot.hasData){
          Map<String, dynamic>? courseData = snapshot.data!.data()! as Map<String, dynamic>?;

          String courseName = courseData?['name'];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // The rounded corners
            ),
            // Add some color to the card
            color: Colors.blue[100],
            child: Center(
              child: Padding(
                // Add some padding to the text
                padding: const EdgeInsets.all(15),
                child: Text(
                  courseName,
                  // Add some style to the text
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
        else{
          return Text('unexpected error');
        }

      },


    );
  }
}
