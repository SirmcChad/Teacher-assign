import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacher_assign/models/StudentModel.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  DatabaseServices services = DatabaseServices();

  void addCourse(BuildContext context){
    String courseName = 'default name';
    final user = Provider.of<User?>(context);
    final TextEditingController _textFieldController = TextEditingController();


    showDialog(context: context, builder: (BuildContext context){
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
                        //TODO Does not exist
                      }
                    } catch(e){
                      //TODO Print error network or something else
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

    setState(() {

    });

  }

  String courseChoice = '';

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    return StreamBuilder<StudentModel>(
      stream: services.getStudentData(user!.uid),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: Text('Welcome Student!'),), // we should show their name here yeah?
          body: Center(
            child: Column(
              children: [
                CustomTextField(title: 'enter Course', initialValue: courseChoice, onChange: (val){courseChoice = val;}),
                ElevatedButton(
                  onPressed: ()async {
                    // there needs to be a provider that updates each time ther is a new course
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[100],
                  ),
                  child: Text('Sign Up',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
