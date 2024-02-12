import 'package:flutter/material.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/cards/student_card.dart';
class CourseTeacher extends StatefulWidget {
  String courseUid;
  CourseTeacher({Key? key, required this.courseUid}) : super(key: key);

  @override
  State<CourseTeacher> createState() => _CourseTeacherState();
}

class _CourseTeacherState extends State<CourseTeacher> {
  List<String> studentNames = [];

  void addStudentName(String name){
    studentNames.add(name);
  }

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
              body: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex){
                    if (oldIndex < newIndex){
                      newIndex = newIndex -1;
                    }
                    studentUids.insert(newIndex, studentUids.removeAt(oldIndex));
                  },
                  itemCount: studentUids.length,
                  itemBuilder: (context, index) {
                    String? studentName;
                    if (index < studentNames.length){
                      studentName = studentNames[index];
                    }

                    return Container(
                        key: GlobalKey(),
                        child: StudentCard(studentUid: studentUids[index], studentName: studentName,)
                    );
                  }
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

