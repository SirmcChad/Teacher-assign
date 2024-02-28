import 'package:flutter/material.dart';
import 'package:teacher_assign/cards/basic_student_card.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/cards/student_card.dart';
import 'package:teacher_assign/shared/utils.dart';
import 'package:teacher_assign/cards/group_card.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseStudent extends StatefulWidget {
  String courseUid;
  CourseStudent({Key? key, required this.courseUid}) : super(key: key);

  @override
  State<CourseStudent> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudent> {

  bool isMyGroup(List<String> studentUids, String uid, int groupIndex, Utility utils){
    List<int> ranges = utils.getRanges();
    bool isMine = false;

    for(int i = ranges[groupIndex]; i < ranges[groupIndex+1]; i++){
      if(studentUids[i] == uid){
        isMine = true;
        break;
      }
    }

    return isMine;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamBuilder<CourseModel?>(
      stream: DatabaseServicesCourses().getCourseData(widget.courseUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> studentUids = snapshot.data!.students;
          String subject = snapshot.data!.courseSubject;
          String teacherName = snapshot.data!.teacherName;
          int studentsPerGroup = snapshot.data!.numberOfStudents;
          int numberOfTasks = snapshot.data!.numberOfTasks;
          int totalStudents = studentUids.length;
          Utility colouringUtility = Utility(numberOfStudentsPerGroup: studentsPerGroup, numberOfTasks: numberOfTasks, totalStudents: totalStudents);
          List<int> ranges = colouringUtility.getRanges();
          print(ranges);

          if(numberOfTasks == 1 && studentsPerGroup == 1){
            return Scaffold(
              appBar: AppBar(
                title: Text(subject),
                backgroundColor: Colors.blue,
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {

                    },
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: studentUids.length,
                itemBuilder: (context, index) {
                  return BasicStudentCard(color: colouringUtility.colouring(index), studentUid: studentUids[index], isMe: false,);
                },
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(teacherName),
                      accountEmail: Text('teacher@example.com'),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/200'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text(subject),
                backgroundColor: Colors.blue,
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {

                    },
                  ),
                ],
              ),
              body: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                shrinkWrap: true,
                children: List.generate(
                    ranges.length - 1,
                        (index) =>
                        GroupCard(studentUids: studentUids,
                            begin: ranges[index],
                            end: ranges[index + 1],
                            groupNumber: index + 1,
                            isMyGroup: isMyGroup(studentUids, user!.uid, index, colouringUtility),
                            myUid: user!.uid,
                        )
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(teacherName),
                      accountEmail: Text('teacher@example.com'),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/200'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Loading();
        }
      },
    );
  }
}

