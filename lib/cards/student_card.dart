import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/constants.dart';
import 'basic_student_card.dart';

class StudentCard extends StatelessWidget {
  final String studentUid;
  final String? pastName;
  Function changeName;
  Color color;
  int index;
  StudentCard({super.key, required this.studentUid, required this.pastName, required this.changeName, required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    if(pastName != null){
      return cardCopyWith(color, listTileCopyWith(pastName!));
    }
    return cardCopyWith(color,  FutureBuilder<DocumentSnapshot>(
      future: DatabaseServicesStudent().studentCollection.doc(studentUid).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return ListTile(title: Text('waiting...'),);
        }
        else if (snapshot.hasData){
          Map<String, dynamic>? studentData = snapshot.data!.data()! as Map<String, dynamic>?;

          String studentName = studentData?['name'];
          changeName(studentName,index);

          return listTileCopyWith(studentName);
        }
        else{
          return ListTile(title: Text('some error occured'));
        }

      },
    ),);
  }
}
