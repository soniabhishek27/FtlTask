import 'package:flutter/material.dart';


//this class will be called when a button is required it requires parameters like button name
// button color and button click event

class MyButton extends StatelessWidget {
  MyButton({this.colour, this.title, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Material(
        elevation: 8.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 40.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0
            ),
          ),
        ),
      ),
    );
  }
}
