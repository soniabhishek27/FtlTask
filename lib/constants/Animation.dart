import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class Animations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
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
