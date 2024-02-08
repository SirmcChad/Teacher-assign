import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:teacher_assign/cards/course_card.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  DatabaseServices services = DatabaseServices();

  void addCourse(BuildContext context){
    String courseName = 'default name';
    final TextEditingController _textFieldController = TextEditingController();


    showDialog(context: context, builder: (BuildContext context){
      final user = Provider.of<User?>(context);
      return AlertDialog(
        title: Text('create a course'),
        content: Column(
          children: [
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Enter course name',
                suffixIcon: ElevatedButton(
                  onPressed: ()async{
                    try{
                      String courseUid = _textFieldController.text;
                      bool exists = await services.courseExists(courseUid);
                      if(exists){
                        services.addCourseToStudent(user!.uid,courseUid);
                        services.addStudentToCourse(courseUid, user!.uid);
                      }
                      else{
                        print("Does not exist");
                      }
                    } catch(e){
                      print("Error");
                    }
                  },
                  child: Text("Add course")
                )
              ),
              onChanged: (value){
                courseName = value;
              },
            )
          ],
        ),

      );
    });

  }

  String courseChoice = '';

  @override
  Widget build(BuildContext context) {
    List<dynamic> coursesList = [];
    final user = Provider.of<User?>(context);

    return StreamBuilder<StudentModel>(
      stream: services.getStudentData(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          coursesList = snapshot.data!.courses;
          return Scaffold(
            appBar: AppBar(
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
            body: Center(
              child: Padding(
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
