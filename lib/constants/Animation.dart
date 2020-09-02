import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


// this class performs animation operations

class Animations extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Lottie.asset('assets/ToDo.json'),
        ),
        Text('Nothing To Do',style: TextStyle(
          fontSize: 20.0
        ),),

        SizedBox(height: 30.0,),

        Text('Click on the + Icon to add tasks',style: TextStyle(
            fontSize: 20.0
        ),),

      ],

    );
  }
}
