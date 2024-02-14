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
  List<String?> names = [];
  DatabaseServicesCourses services = DatabaseServicesCourses();

  void changeName(String name,int index){
    names[index] = name;
  }

  Color colouring(int numberOfTasks, int index){
    if (numberOfTasks == 1) {
      return Colors.blue.shade100 ;
    }
    else {
      return randomColor(index~/numberOfTasks);
    }

  }

  Color randomColor(int index){
    List<Color> colors = [
      Color(0xFF3F51B5), // indigo
      Color(0xFF4CAF50), // green
      Color(0xFF2196F3), // blue
      Color(0xFFE91E63), // pink
      Color(0xFFFFC107), // amber
      Color(0xFFFF5722), // deep orange
      Color(0xFF795548), // brown
      Color(0xFF9C27B0), // purple
    ];

    return colors[index % colors.length];
  }
  void showTasksDialogue(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog();
    });

  }



  @override
  Widget build(BuildContext context) {
      return StreamBuilder<CourseModel?>(
        stream: services.getCourseData(widget.courseUid),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            List<String> studentUids = snapshot.data!.students;
            String subject = snapshot.data!.courseSubject;
            String teacherName = snapshot.data!.teacherName;
            int numberOfTasks = snapshot.data!.numberOfTasks;
            print(numberOfTasks);

            for (int i=0;i<studentUids.length;i++){
              if(i >= names.length){
                names.add(null);
              }

            }

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
              body: ReorderableListView(
                  onReorder: (oldIndex, newIndex){
                    setState(() {
                      if (oldIndex < newIndex){
                        newIndex = newIndex -1;
                      }
                      studentUids.insert(newIndex, studentUids.removeAt(oldIndex));
                      services.changeStudents(widget.courseUid, studentUids);
                      names.insert(newIndex, names.removeAt(oldIndex));
                    });

                  },
                  children: studentUids.map((e) {
                    print(studentUids.indexOf(e));
                    print(colouring(numberOfTasks, studentUids.indexOf(e)));
                    return Container(
                        key: GlobalKey(),
                        child: StudentCard(studentUid: e, pastName: names[studentUids.indexOf(e)], changeName: changeName, index: studentUids.indexOf(e),color: colouring(numberOfTasks, studentUids.indexOf(e)),)
                    );
                  } ).toList()
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
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    numberOfTasks = 2;
                    services.changeTask(widget.courseUid, numberOfTasks);

                  });

                },
                child: Icon(Icons.assignment),
                backgroundColor: Colors.blue,
                // Custom shape for the FAB
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                // Custom elevation for the FAB
                elevation: 10,
                // Custom rotation for the FAB
                clipBehavior: Clip.antiAlias,
              ),
            );
          } else {
            return Loading();
          }
        },
      );
    }
  }

