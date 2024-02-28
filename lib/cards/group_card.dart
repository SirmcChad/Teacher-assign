// import 'package:flutter/material.dart';
// import 'package:teacher_assign/cards/basic_student_card.dart';
//
// class GroupCard extends StatelessWidget {
//   List<String> studentUids;
//   int begin;
//   int end;
//   GroupCard({Key? key, required this.studentUids, required this.begin, required this.end}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: List.generate(end - begin, (index) => BasicStudentCard(studentUid: studentUids[index + begin], color: Colors.blue.shade100)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:teacher_assign/cards/basic_student_card.dart';

class GroupCard extends StatelessWidget {
  List<String> studentUids;
  int begin;
  int end;
  int groupNumber;
  bool isMyGroup;
  String myUid;
  GroupCard({Key? key, required this.studentUids, required this.begin, required this.end, required this.groupNumber, required this.isMyGroup, required this.myUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // add some margin to the container
      margin: EdgeInsets.all(8.0),
      // add a gradient background to the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isMyGroup ? [Colors.green.shade100, Colors.green.shade300] : [Colors.blue.shade100, Colors.blue.shade300],
          stops: [0.5, 1.0],
        ),
      ),
      // add clip behavior to the container
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // add a list tile with a title and a subtitle
          ListTile(
            leading: Icon(Icons.group, color: Colors.white),
            title: Text('Group ${groupNumber}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          // add some padding to the column
          Expanded(
            child: ListView(
                children: List.generate(
                    end - begin, // this is length mein friend
                        (index) => BasicStudentCard(studentUid: studentUids[index + begin], color: studentUids[index + begin] == myUid ? Colors.green.shade100 : Colors.blue.shade100, isMe: studentUids[index + begin] == myUid,)),
            ),
          ),
        ],
      ),
    );
  }
}



