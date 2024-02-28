import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/auth_services.dart';
import 'package:teacher_assign/cards/course_card.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_teacher.dart';
import 'package:teacher_assign/shared/custom_loading.dart';

import '../models/TeacherModel.dart';


class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}




class _TeacherState extends State<Teacher> {




  void addCourse(BuildContext context,String teacherName){
    String courseName = 'default name';


    showDialog(context: context, builder: (BuildContext context){
      final user = Provider.of<User?>(context);

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
            SizedBox(height: 25,),
            ElevatedButton(
              onPressed: () async{
                String courseuid = await DatabaseServicesCourses().newCourse(courseName,teacherName);

                setState(() {
                  DatabaseServicesTeacher().addCourseToTeacher(user!.uid, courseuid);
                  Navigator.pop(context);
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
  // List<CourseModel> fromListOfJSON( List<Map<String,dynamic>> mapList){
  //   List<CourseModel> result = [];
  //   for (int i =0; i< mapList.length;i++){
  //     result.add(CourseModel.fromJson(mapList[i]));
  //   }
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {

    List<String>? coursesList = [];
    final user = Provider.of<User?>(context);


    return StreamBuilder<TeacherModel?>(
      stream:  DatabaseServicesTeacher().getTeacherData(user!.uid),
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          String name = snapshot.data!.name;
          //coursesList = snapshot.data!.courses.cast<CourseModel>();
          coursesList = snapshot.data!.courses;
        return Scaffold(
          drawer: Drawer(

            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Text('Number of Courses: ${coursesList!.length}'),
                    ],
                  ),
                ),
                // Add a ListTile widget that logs out of the account when tapped.
                ListTile(
                  title: const Text('Log Out'),
                  onTap: () {
                    Navigator.pop(context);
                    AuthServices().signOutUser();
                  },
                ),
                // Add more ListTile widgets for other actions or options here.
              ],
            ),
          ),
          appBar:AppBar(
            title: Text('Welcome ${snapshot.data!.name}!'),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.brown,
            elevation: 5,
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                color: Colors.red[300],
                onPressed: () {
                  setState(() {
                    addCourse(context,name);
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
                  Expanded(
                    child: Column(

                      children: coursesList!.map((e) => CourseCard(courseUid: e,isTeacher: true,)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

        );
        }
        else{
          return Loading();
        }
      }
    );
  }


}
