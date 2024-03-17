import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/authentication/choose.dart';
import 'package:teacher_assign/home_pages/StudentHome.dart';
import 'package:teacher_assign/home_pages/TeacherHome.dart';
import 'package:teacher_assign/services/database_services_users.dart';
import 'package:teacher_assign/shared/custom_loading.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    DatabaseServicesUsers userServices = DatabaseServicesUsers();




    if (user == null) {
      return Choose();
    }
    else {
      DocumentReference docRef = userServices.userCollection.doc(user.uid);
      
      // here i want to get the weather the user is a teacher or not, in the meantime of waiting the Loading widget is shown
      return FutureBuilder<DocumentSnapshot>(
        future: docRef.get(), // Future<DocumentSnapshot>
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Loading();
          }
          else if (snapshot.hasData){
            Map<String, dynamic>? userData = snapshot.data!.data()! as Map<String, dynamic>?;

            if (userData?['isTeacher'] == true){
              return Teacher();
            }
            else {
              return Student();
            }
          }
          else{
            return Text('something gone wrong! database could not read');
          }

        },
      );

    }


  }
}
