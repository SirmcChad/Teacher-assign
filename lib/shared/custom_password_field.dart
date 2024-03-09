import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  String title;
  String initialPassword;
  bool visiblePassword;
  Function onChange;

  CustomPasswordField({required this.title, required this.initialPassword, required this.visiblePassword, required this.onChange});

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialPassword,
      obscureText: widget.visiblePassword,
      obscuringCharacter: '*',
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          suffixIcon: IconButton(
            icon: Icon(
                widget.visiblePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black
            ),
            onPressed: (){
              setState(() {
                widget.visiblePassword = !widget.visiblePassword;
              });
            },
          ),
          border: OutlineInputBorder()
      ),
      validator: (value) {
        if (value!.length < 6) {
          return 'Password must be more than 6 characters';
        }
        return null;
      },
      onChanged: (value){
        widget.onChange(value);
      },
    );
  }
}