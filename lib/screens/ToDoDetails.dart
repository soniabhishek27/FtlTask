
import 'package:flutter/material.dart';
import 'package:ftltask/models/ToDo.dart';
import 'package:ftltask/screens/OperationsScreen.dart';
import 'package:ftltask/utils/Database_Helper.dart';
import 'package:share/share.dart';


// this class displays the details of specific to do entry

class ToDoDetails extends StatelessWidget
{
  final id;
  final title;
  final description;

  ToDoDetails(this.id,this.title,this.description);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [

          IconButton(
            onPressed: ()async
            {
              await Share.share("$title\n\n $description");

            },
            icon: Icon(Icons.share),
          )
        ],
        title: Text('To Do Details'),
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
            ),
          )
        ],
      ),

    );
  }

}
