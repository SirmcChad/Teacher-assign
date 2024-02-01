import 'package:flutter/material.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
//Faisal Is Touching the abyss
class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {

  String courseChoice = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome Student!'),), // we should show their name here yeah?
      body: Center(
        child: Column(
          children: [
            CustomTextField(title: 'enter Course', initialValue: courseChoice, onChange: (val){courseChoice = val;}),
            ElevatedButton(
              onPressed: ()async {
                // there needs to be a provider that updates each time ther is a new course
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent[100],
              ),
              child: Text('Sign Up',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
