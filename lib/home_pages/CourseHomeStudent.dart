import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_assign/cards/basic_student_card.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
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

  Future<String> getMyName(List<String> studentUids, String myUid) async{
    String name = 'd';
    for (int i=0; i<studentUids.length;i++){
      DocumentSnapshot snapshot = await DatabaseServicesStudent().studentCollection.doc(studentUids[i]).get();
      if (studentUids[i] == myUid){
        name = snapshot.get('name');
        break;
      }
    }
    return name;
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


          if(numberOfTasks == 1 && studentsPerGroup == 1){
            return Scaffold(
              appBar: AppBar(
                title: Text(subject, style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.blue,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              body: ListView.builder(
                itemCount: studentUids.length,
                itemBuilder: (context, index) {
                  return BasicStudentCard(color: colouringUtility.colouring(index), studentUid: studentUids[index], isMe: false,);
                },
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // use the UserAccountsDrawerHeader widget
                    UserAccountsDrawerHeader(
                      accountName: Text('Teacher Name: ${teacherName}'),
                      accountEmail: Text('Number of students: ${studentUids!.length}'),
                      // add an account picture
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: FutureBuilder<String>(
                          future: getMyName(studentUids, user!.uid),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.done){
                              String? name = snapshot.data;
                              return Text(
                                '${name.toString()[0]}',
                                style: TextStyle(fontSize: 40.0, color: Colors.blue),
                              );
                            }
                            else{
                              return Text(
                                'L',
                                style: TextStyle(fontSize: 40.0, color: Colors.blue),
                              );
                            }

                          },
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
                            title: Text('Exit'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text(subject, style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.blue,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
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
                  padding: EdgeInsets.zero,
                  children: [
                    // use the UserAccountsDrawerHeader widget
                    UserAccountsDrawerHeader(
                      accountName: Text('Teacher Name: ${teacherName}'),
                      accountEmail: Text('Number of students: ${studentUids!.length}'),
                      // add an account picture
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          'b',
                          style: TextStyle(fontSize: 40.0, color: Colors.blue),
                        ),
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
                            title: Text('Exit'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
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

