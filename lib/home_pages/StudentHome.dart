import 'package:flutter/material.dart';
import 'package:teacher_assign/cards/course_card_student.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:teacher_assign/cards/course_card.dart';
import 'package:teacher_assign/models/CourseModel.dart';

import '../services/auth_services.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  DatabaseServicesCourses courseServices = DatabaseServicesCourses();
  DatabaseServicesStudent studentServices = DatabaseServicesStudent();
  String searchText = '';

  List<CourseModel> filteredCourses(List<CourseModel> allCourses, String searchText) {

    return allCourses.where((course) {
      String courseNameLower = course.courseSubject.toLowerCase();
      String searchTextLower = searchText.toLowerCase();
      return courseNameLower.contains(searchTextLower);
    }).toList();
  }

  void _showCourseSearchDialog(BuildContext context) async{
    List<CourseModel> allCourses = await courseServices.getAllData();


    showDialog(
      context: context,
      builder: (context){
        final user = Provider.of<User?>(context);
        return AlertDialog(
          title: Text('Search Courses'),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
            return Container(
              height: 300,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: searchText,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter course name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCourses(allCourses, searchText).length,
                      itemBuilder: (context, index) {
                        print(searchText);
                        CourseModel course = filteredCourses(allCourses, searchText)[index];
                        print(course.numberOfStudents);
                        print(course.teacherName);
                        print(course.students);
                        return ListTile(
                          title: Text(course.courseSubject),
                          subtitle: Text('Teacher: ${course.teacherName}'),
                          onTap: () {
                            // Navigate to course details screen (implement this).
                            // Todo Provide an option for the user to join the course.
                            setState(() {
                              studentServices.addCourseToStudent(user!.uid,course.uid);
                              courseServices.addStudentToCourse(course.uid, user.uid);
                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // void addCourse(BuildContext context){
  //   String courseName = 'default name';
  //   final TextEditingController _textFieldController = TextEditingController();
  //
  //
  //   showDialog(context: context, builder: (BuildContext context){
  //     final user = Provider.of<User?>(context);
  //     return AlertDialog(
  //       title: Text('create a course'),
  //       content: Column(
  //         children: [
  //           TextField(
  //             controller: _textFieldController,
  //             decoration: InputDecoration(
  //               hintText: 'Enter course name',
  //               suffixIcon: ElevatedButton(
  //                 onPressed: ()async{
  //                   try{
  //                     String courseUid = _textFieldController.text;
  //                     bool exists = await courseServices.courseExists(courseUid);
  //                     if(exists){
  //                       setState(() {
  //                         studentServices.addCourseToStudent(user!.uid,courseUid);
  //                         courseServices.addStudentToCourse(courseUid, user!.uid);
  //                         Navigator.pop(context);
  //                       });
  //                     }
  //
  //                     else{
  //                       print("Does not exist");
  //                     }
  //                   } catch(e){
  //                     print("Error");
  //                   }
  //                 },
  //                 child: Text("Add course")
  //               )
  //             ),
  //             onChanged: (value){
  //               courseName = value;
  //             },
  //           )
  //         ],
  //       ),
  //
  //     );
  //   });
  //
  // }
  // List<CourseModel> fromListOfJSON( List<Map<String,dynamic>> mapList){
  //   List<CourseModel> result = [];
  //   for (int i =0; i< mapList.length;i++){
  //     result.add(CourseModel.fromJson(mapList[i]));
  //   }
  //   return result;
  // }

  String courseChoice = '';

  @override
  Widget build(BuildContext context) {
    List<String> coursesList = [];
    final user = Provider.of<User?>(context);

    return StreamBuilder<StudentModel>(
      stream: studentServices.getStudentData(user!.uid),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData){
          coursesList = snapshot.data!.courses;
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // use the UserAccountsDrawerHeader widget
                  UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data!.name),
                    accountEmail: Text('Number of Courses: ${coursesList!.length}'),
                    // add an account picture
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://picsum.photos/200'),
                    ),
                    // add a background image
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://picsum.photos/800/400'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // add other icons

                  ),
                  // use the ListTileTheme widget
                  ListTileTheme(
                    // change the text color and style
                    textColor: Colors.blue,
                    style: ListTileStyle.drawer,
                    // change the icon color and shape
                    iconColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [

                        // use the Divider widget
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Log Out'),
                          onTap: () {
                            Navigator.pop(context);
                            AuthServices().signOutUser();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                  icon: Icon(Icons.add, color: Colors.white),
                  color: Colors.red[300],
                  onPressed: () {
                    setState(() {
                      _showCourseSearchDialog(context);
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
                      Expanded(
                        child: Column(
                          children: coursesList.map((e) => CourseCardStudent(courseUid: e,studentUid: user.uid,)).toList(),
                        ),
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
