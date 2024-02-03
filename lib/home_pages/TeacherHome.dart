import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/auth_services.dart';
import 'package:teacher_assign/services/database_services.dart';
import 'package:teacher_assign/cards/course_card.dart';

import '../models/TeacherModel.dart';
class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}




class _TeacherState extends State<Teacher> {

  DatabaseServices services = DatabaseServices();



  void addCourse(BuildContext context){
    String courseName = 'default name';


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
            ),
            ElevatedButton(
              onPressed: () async{
                setState(() {
                  DatabaseServices().newCourse(courseName);
                });
              },
              child: const Text('Create'),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple, // The background color of the button
                onPrimary: Colors.white, // The foreground color of the button
                shape: RoundedRectangleBorder( // The shape of the button
                  borderRadius: BorderRadius.circular(20), // The rounded corners
                  side: const BorderSide(color: Colors.black, width: 2), // The border
                ),
                elevation: 10, // The elevation of the button
                padding: const EdgeInsets.all(15), // The padding of the button
              ),
            )
          ],
        ),

      );
    });



  }

  @override
  Widget build(BuildContext context) {

    List<CourseModel> coursesList = [];
    final user = Provider.of<User?>(context);


    return StreamBuilder<TeacherModel?>(
      stream:  DatabaseServices().getTeacherData(user!.uid),
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          coursesList = snapshot.data!.courses;
        }
        return Scaffold(
          appBar:AppBar(
            title: Text('Welcome ${snapshot.data!.name}!'),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.blue,
            elevation: 5,
            actions: [
              IconButton(
                icon: Icon(Icons.add), 
                onPressed: () {
                  setState(() {
                    addCourse(context);
                  });
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Text('here are your courses:'),
                  Column(
                    
                    children: coursesList.map((e) => CourseCard(courseName: e.courseSubject)).toList(),
                  ),
                ],
              ),
            ),
          ),

        );
      }
    );
  }
}
