import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/cards/student_card.dart';
import 'package:teacher_assign/shared/utils.dart';


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




  void showTasksDialogue(BuildContext context){
    int numberOfTasks = 1;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Assign Tasks"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("How many tasks do you want to assign for your class?"),
            SizedBox(height: 10),
            // A text field to enter the number of tasks
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter> [
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Number of tasks",
              ),
              onChanged: (value) {
                // Update the number of tasks variable
                numberOfTasks = int.parse(value);
              },
            ),
          ],
        ),
        actions: [
          // A cancel button to dismiss the dialog
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // A confirm button to assign the tasks and return the number
          TextButton(
            child: Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);
              services.changeTask(widget.courseUid, numberOfTasks);
            },
          ),
        ],
      );
    });
  }
  void showStudentPerGroupDialogue(BuildContext context){
    int numberOfTasks = 1;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Assign Tasks"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("How many students in a single group?"),
            SizedBox(height: 10),
            // A text field to enter the number of tasks
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter> [
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Number of Students in a Group",
              ),
              onChanged: (value) {
                // Update the number of tasks variable
                numberOfTasks = int.parse(value);
              },
            ),
          ],
        ),
        actions: [
          // A cancel button to dismiss the dialog
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // A confirm button to assign the tasks and return the number
          TextButton(
            child: Text("Confirm"),
            onPressed: () {
              services.changeStudentsPerGroup(widget.courseUid, numberOfTasks);
              Navigator.pop(context);
            },
          ),
        ],
      );
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
            int studentsPerGroup = snapshot.data!.numberOfStudents;
            int numberOfTasks = snapshot.data!.numberOfTasks;
            int totalStudents = studentUids.length;
            Utility colouringUtility = Utility(numberOfStudentsPerGroup: studentsPerGroup, numberOfTasks: numberOfTasks, totalStudents: totalStudents);


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
                    int index = studentUids.indexOf(e);
                    return Container(
                        key: GlobalKey(),
                        child: StudentCard(studentUid: e, pastName: names[studentUids.indexOf(e)], changeName: changeName, index: studentUids.indexOf(e),color: colouringUtility.colouring(index))
                    );
                  } ).toList()
              ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // A drawer header with a circle avatar and the teacher name
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          teacherName,
                          style: TextStyle(fontSize: 24.0),
                        ),
                        accountEmail: Text('john.smith@example.com'),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            '${teacherName[0]}',
                            style: TextStyle(fontSize: 40.0, color: Colors.blue),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://picsum.photos/300'), // TODO: replace with a background image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // A list tile with an icon and a text for assigning tasks per number of groups
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text(
                          'Assign Tasks per Number of Groups',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          showTasksDialogue(context);
                        },
                      ),
                      // A list tile with an icon and a text for assigning tasks per number of students
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          'Assign Tasks per Number of Students',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          showStudentPerGroupDialogue(context);
                        },
                      ),
                      // A divider to separate the list tiles
                      Divider(
                        color: Colors.grey,
                        height: 10,
                        thickness: 1,
                      ),
                      // A list tile with an icon and a text for logout
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text(
                          'Logout',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    showTasksDialogue(context);


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

