import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services.dart';

class CourseCard extends StatelessWidget {
  String courseName;
   CourseCard({Key? key,required this.courseName}) : super(key: key);

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
}
