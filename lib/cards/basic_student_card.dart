import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/constants.dart';
class BasicStudentCard extends StatelessWidget {
  final String studentUid;
  final Color color;
  final bool isMe;
  const BasicStudentCard({super.key, required this.studentUid, required this.color, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return cardCopyWith(
      color,
      FutureBuilder<DocumentSnapshot>(
        future: DatabaseServicesStudent().studentCollection.doc(studentUid).get(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return ListTile(title: Text('waiting...'),);
          }
          else if (snapshot.hasData){
            Map<String, dynamic>? studentData = snapshot.data!.data()! as Map<String, dynamic>?;

            String studentName = studentData?['name'];
            return listTileCopyWith(studentName, isMe);
          }
          else{
            return ListTile(title: Text('some error occured'));
          }

          },

      )
    );
  }
}
