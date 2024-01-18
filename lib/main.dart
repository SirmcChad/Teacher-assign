import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/Wrapper.dart';
import 'package:teacher_assign/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyB3_khYTxEXJlp5PQHbDpQ3XBnnt4kRKoY", appId: "1:25180355323:web:ca7eff860643d4e3b3ce5e""1:25180355323:web:ca7eff860643d4e3b3ce5e", messagingSenderId: "25180355323", projectId: "teacherassign"));


  runApp(StreamProvider<User?>.value(
    value: AuthServices().user,
    catchError: (User, user){},
    initialData: null,
    child: const MaterialApp(
      home: Wrapper(),
    ),
  ));
}