import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/Wrapper.dart';
import 'package:teacher_assign/services/auth_services.dart';
import 'home_pages/CourseHomeStudent.dart';
import 'home_pages/CourseHomeTeacher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyB3_khYTxEXJlp5PQHbDpQ3XBnnt4kRKoY", appId: "1:25180355323:web:ca7eff860643d4e3b3ce5e""1:25180355323:web:ca7eff860643d4e3b3ce5e", messagingSenderId: "25180355323", projectId: "teacherassign"));


  runApp(StreamProvider<User?>.value(
    value: AuthServices().user,
    catchError: (User, user){},
    initialData: null,
    child: MaterialApp(
      home: Wrapper(),
    ),
  ));
}

/*
TODO 1- courses joined by name instead of being joined by UID DONE!
TODO 2- singing out users DONE!
TODO 3- crown of users DONE!
TODO 4- UI improvements including maybe animations.
TODO 5- modifying firebase firestore rules.
TODO 6- sign out user hitbox DONE!
TODO 7- un enroll in a course DONE!
TODO 8- banning a student from a course
TODO 9- removing a course from the course home page. DONE!
 */