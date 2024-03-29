import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/constants.dart';

class StudentCard extends StatelessWidget {
  final String studentUid;
  String courseUid;
  Function delete;
  final String? pastName;
  Function changeName;
  Color color;
  int index;
  bool shuffled;
  StudentCard({super.key, required this.studentUid,required this.courseUid, required this.pastName, required this.changeName, required this.index, required this.color, required this.shuffled, required this.delete});

  @override
  Widget build(BuildContext context) {
    if(pastName != null && !shuffled){
      return cardCopyWithDeletion(color, listTileCopyWith(pastName!, false), studentUid,delete);
    }
    return cardCopyWithDeletion(color,  FutureBuilder<DocumentSnapshot>(
      future: DatabaseServicesStudent().studentCollection.doc(studentUid).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return ListTile(title: Text('waiting...'),);
        }
        else if (snapshot.hasData){
          Map<String, dynamic>? studentData = snapshot.data!.data()! as Map<String, dynamic>?;

          String studentName = studentData?['name'];
          changeName(studentName,index);

          return listTileCopyWith(studentName, false);
        }
        else{
          return ListTile(title: Text('some error occured'));
        }

      },
    ),studentUid,delete);
  }
}
