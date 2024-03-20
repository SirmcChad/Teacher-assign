import 'package:flutter/material.dart';
import 'package:teacher_assign/cards/course_card_student.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacher_assign/models/StudentModel.dart';
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

  List<CourseModel> filteredCourses(List<CourseModel> allCourses, String searchText, List<String> myCourses) {
    List<CourseModel> filteredCourse = allCourses.where((course) {
      String courseNameLower = course.courseSubject.toLowerCase();
      String searchTextLower = searchText.toLowerCase();
      return courseNameLower.contains(searchTextLower) && !myCourses.contains(course.uid);
    }).toList();

    filteredCourse.shuffle();

    if(filteredCourse.length < 15){
      return filteredCourse;
    }
    else{
      return filteredCourse.sublist(0,15);
    }
  }

  String hereAreCourses(int numberOfCourses){
    if (numberOfCourses ==0){
      return 'Start adding courses by clicking the join + course button top right';
    }
    else{
      return 'Here Are Your Courses:';
    }
  }

  void _showEnterPasswordDialog(BuildContext context, String courseUid){
    String password = '';
    String error = '';

    showDialog(
        context: context,
        builder: (context){
          final user = Provider.of<User?>(context);

          return AlertDialog(
            title: Text('Password Required'),
            content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value){
                      password = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Password'
                    ),
                  ),
                  const SizedBox(height: 25,),
                  ElevatedButton(
                      onPressed: ()async{
                        try{
                          if(await courseServices.checkPassword(courseUid, password)){
                           await studentServices.addCourseToStudent(user!.uid,courseUid);
                            courseServices.addStudentToCourse(courseUid, user.uid);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                          else{
                            setState((){
                              error = 'Wrong Password';
                            });
                            //Todo: Implement wrong password message
                          }
                        }catch(e){
                          setState((){
                            error = 'An Error Occured While Checking Password';
                          });
                          //Todo: Implement error message
                        }
                      },
                      child: Text('Join Course')),
                  const SizedBox(height: 25,),

                  Text(error, style: TextStyle(color: Colors.red))
                ],
              );
            })
          );
        }
    );
  }

  void _showCourseSearchDialog(BuildContext context, List<String> coursesList) async{
    List<CourseModel> allCourses = await courseServices.getAllData();
    String error = '';

    showDialog(
      context: context,
      builder: (context){
        final user = Provider.of<User?>(context);
        return AlertDialog(
          shadowColor: Colors.white30,
          title: Text('Search Courses'),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
            List<CourseModel> filtCourses = filteredCourses(allCourses, searchText, coursesList);
            return Container(
              height: 300,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autofocus: true,
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
                    child: Container(
                      color: Colors.white.withRed(245),
                      child: ListView.builder(
                        itemCount: filtCourses.length == 0 ? 1: filtCourses.length,
                        itemBuilder: (context, index) {
                          if (filtCourses.length == 0){
                            return ListTile(
                              title: Text("No Course Matches Your Description", style: TextStyle(fontSize: 14),)
                            );
                          }
                          CourseModel course = filtCourses[index];
                          return ListTile(
                            title: Text(course.courseSubject),
                            subtitle: Text('Teacher: ${course.teacherName}'),
                            onTap: () {
                              // Navigate to course details screen (implement this).
                              // Todo Provide an option for the user to join the course.
                              if(course.students.length >= 50){
                                setState((){
                                  error = 'The Course is Full';
                                });
                              }

                              else if(coursesList.length >= 20){
                                setState((){
                                  error = 'Maximum Number of Courses Reached';
                                });
                                //Todo, display message saying that you have reached the maximum number of courses
                              }

                              else if(course.password == ''){
                                setState(() async{
                                  await studentServices.addCourseToStudent(user!.uid,course.uid);
                                  courseServices.addStudentToCourse(course.uid, user.uid);
                                  Navigator.pop(context);
                                });
                              }
                              else{
                                _showEnterPasswordDialog(context, course.uid);
                              }
                              });
                            },
                          )
                        ),
                      ),
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 18),),
                    ],
                    ),
                  );
              }),
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

  String courseChoice = '';

  @override
  Widget build(BuildContext context) {
    List<String> coursesList = [];
    final user = Provider.of<User?>(context);

    return StreamBuilder<StudentModel>(
      stream: studentServices.getStudentData(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          coursesList = snapshot.data!.courses;
          String name = snapshot.data!.name;
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // use the UserAccountsDrawerHeader widget
                  UserAccountsDrawerHeader(
                    accountName: Text(name),
                    accountEmail: Text('Number of Courses: ${coursesList!.length}'),
                    // add an account picture
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        '${name[0]}',
                        style: TextStyle(fontSize: 40.0, color: Colors.blue),
                      ),
                    ),
                    // add a background image
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://picsum.photos/id/84/800/400'),
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
              title: Text('Hi ${snapshot.data!.name}!'),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.blue,
              elevation: 5,
              actions: [
                TextButton.icon(
                    onPressed: (){
                      setState(() {
                        _showCourseSearchDialog(context, coursesList);
                      });
                    },
                    icon: Icon(Icons.add,color: Colors.white,),
                    label: Text('Join Course',style: TextStyle(color: Colors.white),))
                // IconButton(
                //   icon: Icon(Icons.add, color: Colors.white),
                //   color: Colors.red[300],
                //   onPressed: () {
                //     setState(() {
                //       _showCourseSearchDialog(context, coursesList);
                //     });
                //   },
                // ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(hereAreCourses(snapshot.data!.courses.length), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      const SizedBox(height:8),
                      Expanded(
                        // use a GridView widget instead of a Column widget
                        child: GridView.builder(
                          // set the scroll direction to horizontal
                          scrollDirection: Axis.vertical,
                          // set the cross axis count to 2
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            // set the aspect ratio of each item to 1.5
                            childAspectRatio: 1.5,
                          ),
                          // set the item count to the length of the courses list
                          itemCount: coursesList!.length,
                          // return a Card widget for each item
                          itemBuilder: (context, index) {
                            return Card(
                              // set the shape property to customize the border radius
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // wrap the CourseCardTeacher widget with the Card widget
                              child: CourseCardStudent(
                                  courseUid: coursesList![index],
                                  studentUid: user.uid),
                            );
                          },
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
