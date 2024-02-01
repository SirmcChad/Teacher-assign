import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/auth_services.dart';
import 'package:teacher_assign/services/database_services.dart';
//Faisal touch
class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

// fahad touch



class _TeacherState extends State<Teacher> {

  DatabaseServices services = DatabaseServices();



  void addCourse(BuildContext context){
    String courseName = 'default name';
    final user = Provider.of<User?>(context);


    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('create a course'),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'course name'),
              onChanged: (value){
                courseName = value;
              },

            )
          ],
        ),

      );
    });

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: null,
      builder: (context, snapshot) {
        return Scaffold(
          body: Center(child: Text('Hello Teacher!'),),
        );
      }
    );
  }
}
