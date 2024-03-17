import 'package:flutter/material.dart';
import 'package:teacher_assign/authentication/AuthenticateStudent.dart';
import 'package:teacher_assign/authentication/AuthenticateTeacher.dart';
import 'package:teacher_assign/services/auth_services.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {

  final _auth = AuthServices();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Registration',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.red,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Teacher',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      onPressed: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  AuthenticateTeacher()));

                      },
                      child: Text('Register as Teacher',style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            Card(
              color: Colors.blue,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  AuthenticateStudent()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: Text('Register as Student', style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}