import 'package:flutter/material.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_student.dart';

Card cardCopyWith(Color color, Widget child){
  return Card(
      // Add some margin to the card
      margin: const EdgeInsets.all(10),
      // Add some elevation to the card
      elevation: 5,
      // Add some shape to the card
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // The rounded corners
      ),
      // Add some color to the card
      color: color,
      child: Center(
        child: Padding(
          // Add some padding to the text
          padding: const EdgeInsets.all(5),
          child: child
        ),
      ),
  );
}

Card cardCopyWithDeletion(Color color, Widget child, String studentUid, Function delete){

  return Card(
    // Add some margin to the card
    margin: const EdgeInsets.all(10),
    // Add some elevation to the card
    elevation: 5,
    // Add some shape to the card
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // The rounded corners
    ),
    // Add some color to the card
    color: color,
    child: Stack(
      children: [
        Center(
          child: Padding(
            // Add some padding to the text
            padding: const EdgeInsets.all(5),
            child: child,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: PopupMenuButton(
              onSelected: (value) {
                if (value == 'delete') {
                  delete(studentUid);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );


}


ListTile listTileCopyWith(String name, bool isMe){
  if(isMe){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://picsum.photos/id/193/200'), // TODO: replace with student profile image
      ),
      title: Text(name),
      trailing:IconButton(
        icon:Icon(Icons.star),
        onPressed: () {
          // TODO: implement message functionality
        },
      ),
    );
  }
  else{
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://picsum.photos/id/193/200'),
      ),
      title: Text(name),

    );
  }
}