import 'package:flutter/material.dart';

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