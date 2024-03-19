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
  bool shuffled = false;

  void changeName(String name,int index){
    names[index] = name;
  }




  void showTasksDialogue(BuildContext context){
    int numberOfTasks = 1;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Assign Groups"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("How many Groups/tasks do you want to assign for your class?"),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // A confirm button to assign the tasks and return the number
            TextButton(
              child: Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.pop(context);
                services.changeTask(widget.courseUid, numberOfTasks);
              },
            ),
          ],)

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
          ),
        ],
      );
    });
  }

  void sureShuffle(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Shuffle Students"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to shuffle the order of the students?"),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // A confirm button to assign the tasks and return the number
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  services.shuffleStudentList(widget.courseUid);
                  shuffled = true;
                  Navigator.pop(context);
                },
                child: const Text('Shuffle'),
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

            ],)

        ],
      );
    });
  }

  void updateCourseName(BuildContext context,String courseUid){
    String courseName = '';

    showDialog(context: context, builder: (BuildContext context){
      String error = '';

      return AlertDialog(
        title: Text('Update the Course Name'),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'New Course name', hintText: 'Leave Blank For no Change'),
                onChanged: (value) {
                  courseName = value;
                },
              ),
              SizedBox(height: 25,),
              ElevatedButton(
                onPressed: () async {
                  services.updateCourseName(courseUid, courseName);
                  Navigator.pop(context);
                },
                child: const Text('Update'),
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

  void updateCoursePassword(BuildContext context,String courseUid){
    String password = '';

    showDialog(context: context, builder: (BuildContext context){
      String error = '';

      return AlertDialog(
        title: Text('Update the Password'),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'New Password', hintText: 'Leave Blank For no Password'),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 25,),
              ElevatedButton(
                onPressed: () async {
                  services.updateCourseName(courseUid, password);
                  Navigator.pop(context);
                },
                child: const Text('Update'),
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

            bool showFloating = !(numberOfTasks == 1 && studentsPerGroup ==1);


            for (int i=0;i<studentUids.length;i++){
              if(i >= names.length){
                names.add(null);
              }
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(subject, style: TextStyle(fontSize: 16, color: Colors.white),),
                backgroundColor: Colors.indigo.shade400,
                iconTheme: IconThemeData(
                    color: Colors.white
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      showTasksDialogue(context);
                    },
                    icon: Icon(Icons.person,color: Colors.grey.shade200,),
                    label: Text('by groups',style: TextStyle(color: Colors.grey.shade200),),
                  ),
                  SizedBox(width: 10,),
                  TextButton.icon(
                    onPressed: () {
                      showStudentPerGroupDialogue(context);
                    },
                    icon: Icon(Icons.groups,color:Colors.grey.shade200,),
                    label: Text('by size',style: TextStyle(color: Colors.grey.shade200),),
                  ),


                ],
              ),
              body: ReorderableListView(
                  onReorder: (oldIndex, newIndex){
                    setState(() {
                      shuffled = false;
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
                        child: StudentCard(studentUid: e, pastName: names[studentUids.indexOf(e)], changeName: changeName, index: studentUids.indexOf(e),color: colouringUtility.colouring(index,), shuffled: shuffled,)
                    );
                  } ).toList()
              ),
                floatingActionButton: Visibility(
                  visible: showFloating,
                  child: FloatingActionButton(
                    onPressed: (){
                      setState(() {
                        services.changeTask(widget.courseUid, 1);
                      });
                    },
                    child: Icon(Icons.cancel),
                  ),
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
                        accountEmail: Text(''),
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
                                'https://picsum.photos/id/122/800/400'),
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

                      ListTile(
                        leading: Icon(Icons.restart_alt),
                        title: Text(
                          'Shuffle',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          setState(() {
                            sureShuffle(context);
                          });
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(
                          'Update Course Name',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          setState(() {
                            updateCourseName(context, widget.courseUid);
                          });
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.password),
                        title: Text(
                          'Update Course Password',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          setState(() {
                            updateCoursePassword(context, widget.courseUid);
                          });
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
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("\"Hold and drag students to rearrange their order\"",style: TextStyle(fontSize: 15),),
                      )
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

