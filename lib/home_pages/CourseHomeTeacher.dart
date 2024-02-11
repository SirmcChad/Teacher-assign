import 'package:flutter/material.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/shared/custom_loading.dart';

class CourseTeacher extends StatefulWidget {
  String courseUid;
  CourseTeacher({Key? key, required this.courseUid}) : super(key: key);

  @override
  State<CourseTeacher> createState() => _CourseTeacherState();
}

class _CourseTeacherState extends State<CourseTeacher> {

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<CourseModel?>(
        stream: DatabaseServicesCourses().getCourseData(widget.courseUid),
        builder: (context, snapshot) {
          print(snapshot);
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
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      // TODO: implement more options
                    },
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: studentUids.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://picsum.photos/200'), // TODO: replace with student profile image
                    ),
                    title: Text(studentUids[index]),
                    // TODO: replace with student name
                    subtitle: Text('Enrolled on ${DateTime.now()}'),
                    // TODO: replace with enrollment date
                    trailing: IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        // TODO: implement message functionality
                      },
                    ),
                  );
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

