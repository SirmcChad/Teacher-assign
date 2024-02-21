import 'package:flutter/material.dart';
import 'package:teacher_assign/shared/custom_password_field.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import '../services/auth_services.dart';

class RegisterStudent extends StatefulWidget {
  Function toggleView;
  RegisterStudent({Key? key,required this.toggleView}) : super(key: key);

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthServices();

  String email = "";
  String password = "";
  String name = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return Loading();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {widget.toggleView();}
              ),
              Text("Sign In")
            ],
          )
        ],
        title: Text('Sign Up Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(title: "Name", initialValue: email, onChange: (value) {name = value;}),
              SizedBox(height: 30,),
              CustomTextField(title: "Email", initialValue: email, onChange: (value) {email = value;}),
              SizedBox(height: 30,),
              CustomPasswordField(title: "Password", initialPassword: password, visiblePassword: false, onChange: (value) {password = value;},),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: ()async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {isLoading = true;});

                    dynamic result = await _auth.signUpWithEmailAndPasswordStudent(email, password,name);
                    if (result !=null){
                      Navigator.pop(context);
                    }
                    else{
                      //TODO handle displaying the error message
                    }

                    setState(() {isLoading = false;});
                  }
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
      ),
    );
  }
}
