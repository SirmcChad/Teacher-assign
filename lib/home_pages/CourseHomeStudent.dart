import 'package:flutter/material.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/cards/student_card.dart';

class CourseStudent extends StatefulWidget {
  String courseUid;
  CourseStudent({Key? key, required this.courseUid}) : super(key: key);

  @override
  State<CourseStudent> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudent> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CourseModel?>(
      stream: DatabaseServicesCourses().getCourseData(widget.courseUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> studentUids = snapshot.data!.students;
          String subject = snapshot.data!.courseSubject;
          String teacherName = snapshot.data!.teacherName;
          return Scaffold(
            appBar: AppBar(
              title: Text(subject),
              backgroundColor: Colors.blue,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // TODO: implement search functionality
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: studentUids.length,
              itemBuilder: (context, index) {
                return Container();
                // return StudentCard(studentUid: studentUids[index]);
                //ListTile(
                //   leading: CircleAvatar(
                //     backgroundImage: NetworkImage(
                //         'https://picsum.photos/200'), // TODO: replace with student profile image
                //   ),
                //   title: Text(studentUids[index]),
                //   // TODO: replace with student name
                //   subtitle: Text('Enrolled on ${DateTime.now()}'),
                //   // TODO: replace with enrollment date
                //   trailing: IconButton(
                //     icon: Icon(Icons.message),
                //     onPressed: () {
                //       // TODO: implement message functionality
                //     },
                //   ),
                // );
              },
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(teacherName),
                    accountEmail: Text('teacher@example.com'),
                    // TODO: replace with teacher email
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://picsum.photos/200'), // TODO: replace with teacher profile image
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      // TODO: implement home navigation
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      // TODO: implement settings navigation
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      // TODO: implement logout functionality
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

