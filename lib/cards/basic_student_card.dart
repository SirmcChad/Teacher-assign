import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/constants.dart';
class BasicStudentCard extends StatelessWidget {
  final String studentUid;
  final Color color;
  const BasicStudentCard({super.key, required this.studentUid, required this.color});

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
            return listTileCopyWith(studentName);
          }
          else{
            return ListTile(title: Text('some error occured'));
          }

          },

      )
    );
    //   Card(
    //   // Add some margin to the card
    //   margin: const EdgeInsets.all(10),
    //   // Add some elevation to the card
    //   elevation: 5,
    //   // Add some shape to the card
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15), // The rounded corners
    //   ),
    //   // Add some color to the card
    //   color: Colors.blue[100],
    //   child: Center(
    //     child: Padding(
    //       // Add some padding to the text
    //       padding: const EdgeInsets.all(15),
    //       child: FutureBuilder<DocumentSnapshot>(
    //         future: DatabaseServicesStudent().studentCollection.doc(studentUid).get(),
    //         builder: (context, snapshot){
    //           if (snapshot.connectionState == ConnectionState.waiting){
    //             return ListTile(title: Text('waiting...'),);
    //           }
    //           else if (snapshot.hasData){
    //             Map<String, dynamic>? studentData = snapshot.data!.data()! as Map<String, dynamic>?;
    //
    //             String studentName = studentData?['name'];
    //             return ListTile(
    //               leading: CircleAvatar(
    //                 backgroundImage: NetworkImage(
    //                     'https://picsum.photos/200'),
    //               ),
    //               title: Text(studentName),
    //               subtitle: Text('Enrolled on ${DateTime.now()}'),
    //               trailing: IconButton(
    //                 icon: Icon(Icons.message),
    //                 onPressed: () {
    //                 },
    //               ),
    //             );
    //           }
    //           else{
    //             return ListTile(title: Text('some error occured'));
    //           }
    //
    //         },
    //
    //       ),
    //     ),
    //   ),
    // );
  }
}
