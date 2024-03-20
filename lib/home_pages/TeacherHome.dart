import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/cards/course_card_teacher.dart';
import 'package:teacher_assign/services/auth_services.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_teacher.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/shared/snackbar_messager.dart';

import '../models/TeacherModel.dart';


class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}




class _TeacherState extends State<Teacher> {




  void addCourse(BuildContext context,String teacherName, List<String> courses){
    String courseName = 'default name';
    String password = '';
    Message message = Message(context: context);


    showDialog(context: context, builder: (BuildContext context){
      final user = Provider.of<User?>(context);
      String error = '';

      return AlertDialog(
        title: Text('create a course'),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Course name'),
                onChanged: (value) {
                  courseName = value;
                },
              ),
              SizedBox(height: 15,),
              TextField(
                decoration: InputDecoration(labelText: 'Password',
                    hintText: 'Leave Blank For no Password'),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 25,),
              ElevatedButton(
                onPressed: () async {
                  if (courses.length >= 5) { // TODO remove this before publishing
                    setState(() {
                      error = "Maximum number of courses exceeded";
                    });
                  }

                  else {
                    String courseuid = await DatabaseServicesCourses()
                        .newCourse(
                        courseName, teacherName, password);

                    setState(() {
                      DatabaseServicesTeacher().addCourseToTeacher(
                          user!.uid, courseuid);
                      Navigator.pop(context);
                      message.showCustomLovely('Course Created Successfully', 3);
                    });
                  }
                },
                child: const Text('Create'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder( // The shape of the button
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.black,
                        width: 2), // The border
                  ),
                  elevation: 10,
                  // The elevation of the button
                  padding: const EdgeInsets.all(
                      15), // The padding of the button
                ),
              ),
              Text(error, style: TextStyle(color: Colors.red,fontSize: 18),),
            ],
          );

        }
        ),

      );
    });


  }

  @override
  Widget build(BuildContext context) {

    List<String>? coursesList = [];
    final user = Provider.of<User?>(context);

    String hereAreCourses(int numberOfCourses){
      if (numberOfCourses ==0){
        return 'Start adding courses by clicking the + Icon';
      }
      else{
        return 'Here Are Your Courses:';
      }
    }


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
                          'https://picsum.photos/id/122/800/400'),
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
          appBar:AppBar(
            title: Text('Welcome ${name}!'),
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
                    addCourse(context,name, coursesList!);
                  });
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text(hereAreCourses(coursesList!.length), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
                          child: CourseCardTeacher(
                              courseUid: coursesList![index],
                              teacherUid: user.uid),
                        );
                      },
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
