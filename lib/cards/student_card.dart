import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_student.dart';
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
        color: color,
        child: Center(
          child: Padding(
            // Add some padding to the text
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://picsum.photos/200'), // TODO: replace with student profile image
              ),
              title: Text(pastName!),
              // TODO: replace with student name
              subtitle: Text('Enrolled on ${DateTime.now()}'),
              // TODO: replace with enrollment date
              trailing: IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  // TODO: implement message functionality
                },
              ),
            )
          ),
        ),
      );
    }
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
      color: color,
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
                changeName(studentName,index);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://picsum.photos/200'), // TODO: replace with student profile image
                  ),
                  title: Text(studentName),
                  // TODO: replace with student name
                  subtitle: Text('Enrolled on ${DateTime.now()}'),
                  // TODO: replace with enrollment date
                  trailing: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      // TODO: implement message functionality
                    },
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
