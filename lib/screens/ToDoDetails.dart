
import 'package:flutter/material.dart';


class ToDoDetails extends StatelessWidget
{
  final title;
  final description;

  ToDoDetails(this.title,this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),

      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('$title',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0
            ),),
          ),

          SizedBox(height: 10.0,),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                '$description',
              style: TextStyle(
                fontSize: 20.0
              ),
              textAlign: TextAlign.justify,
            )
            ,
          )


        ],
      ),


    );
  }
}
