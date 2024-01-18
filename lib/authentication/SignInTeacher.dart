import 'package:flutter/material.dart';
import 'package:teacher_assign/shared/custom_password_field.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';


class SignInTeacher extends StatefulWidget {
  const SignInTeacher({super.key});

  @override
  State<SignInTeacher> createState() => _SignInTeacherState();
}

class _SignInTeacherState extends State<SignInTeacher> {

  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In Teacher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(title: "Email", initialValue: email, onChange: (value) {email = value;}),
              SizedBox(height: 30,),
              CustomPasswordField(title: "Password", initialPassword: password, visiblePassword: false, onChange: (value) {password = value;},),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(email);
                    print(password);
                    // TODO: Put Fahad's Function
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[100],
                ),
                child: Text('Sign In',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}