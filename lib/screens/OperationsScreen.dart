import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:ftltask/models/ToDo.dart';
import 'package:ftltask/utils/Database_Helper.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:intl/intl.dart';



class OperationsScreen extends StatefulWidget
{

  static String id = 'OperationsScreen';
  final String appBarTitle;
  final ToDoHelperClass todoh;

  OperationsScreen(this.todoh,this.appBarTitle);

  @override
  State<StatefulWidget> createState()
  {

    return _OperationsScreenState(this.todoh, this.appBarTitle);
  }




  // @override
  // _OperationsScreenState createState() => _OperationsScreenState();
}




class _OperationsScreenState extends State<OperationsScreen>
{

  DatabaseHelper helper = DatabaseHelper();


  final _formKey = GlobalKey<FormState>();


  stt.SpeechToText _speech;
  bool isListening = false;
  String text = "Press the button and Start Speaking";

  String appBarTitle;
  ToDoHelperClass todo;

  _OperationsScreenState(this.todo,this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();





  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();


  }


  @override
  Widget build(BuildContext context)
  {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = todo.title;
    descriptionController.text = todo.description;
    print("titile is ${todo.title}");
    print(todo.description);
    print("Id is ${todo.id}");

    return Scaffold(
      appBar: AppBar(
        title: Text('$appBarTitle'),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          children: [

            //Title

            Row(
              children: [
                IconButton(
                  onPressed: ()
                  {
                    listen2();

                  },
                  icon: Icon(Icons.keyboard_voice,
                    size: 35.0,
                    color: isListening == true ? Colors.red :  Colors.black,

                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextFormField(
                      validator: (value)
                      {
                        return value.isEmpty ? 'Title is required' : null;

                      },
                      maxLines: 1,
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value)
                      {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();

                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),
                ),


              ],
            ),

            //Description
            Row(
              children: [
                IconButton(
                  onPressed: ()
                  {
                    listen();

                  },
                  icon: Icon(Icons.keyboard_voice,
                    size: 35.0,
                    color: isListening == true ? Colors.red :  Colors.black,

                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextFormField(
                      validator: (value)
                      {
                        return value.isEmpty ? 'Description is required' : null;

                      },
                      maxLines: 2,
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value)
                      {
                        debugPrint('Something changed in Description Text Field');
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 10.0,),

            appBarTitle == 'Add' ?Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Save button clicked");
                          save();
                        });
                      },
                    ),
                  ),

                  Container(width: 5.0,),

                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete button clicked");
                          // _delete();
                        });
                      },
                    ),
                  ),

                ],
              ),
            ):
            RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Theme.of(context).primaryColorLight,
              child: Text(
                'Update',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Save button clicked");
                  update();
                });
              },
            ),


          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }


  void listen() async
  {
    if(!isListening)
    {
      print("Inside if 1");
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus $val'),
        onError: (val) => print('onError $val'),
      );
      if (available)
      {
        print("Inside if 2");

        setState(() {
          isListening = true;
        });
        _speech.listen(
            onResult: (val)
            {
              setState(()
              {
                text = val.recognizedWords;
                descriptionController.value = descriptionController.value.copyWith(
                  text: text,
                  selection: TextSelection(baseOffset: text.length ,extentOffset: text.length),
                  composing: TextRange.empty,
                );

                // isListening = false;
              }
              );
            }
        );

      }

    }
    else
    {
      setState(() {
        isListening = false;
        _speech.stop();
      });
      print("NI else part");

    }

  }

  void listen2() async
  {
    if(!isListening)
    {
      print("Inside if 1");
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus $val'),
        onError: (val) => print('onError $val'),
      );
      if (available)
      {
        print("Inside if 2");

        setState(() {
          isListening = true;
        });
        _speech.listen(
            onResult: (val)
            {
              setState(()
              {
                text = val.recognizedWords;
                titleController.value = titleController.value.copyWith(
                  text: text,
                  selection: TextSelection(baseOffset: text.length ,extentOffset: text.length),
                  composing: TextRange.empty,
                );

                // isListening = false;
              }
              );
            }
        );

      }

    }
    else
    {
      setState(() {
        isListening = false;
        _speech.stop();
      });
      print("NI else part");

    }

  }

  void updateTitle(){
    todo.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    todo.description = descriptionController.text;
  }


  void update() async
  {
    moveToLastScreen();

    int result;

    var id = todo.id;
    var title = titleController.text;
    var desc = descriptionController.text;

    result = await helper.updateData(title, desc, id);

    if (result != 0)
    {
      showAlertDialog("Status", "Data Updated Successfully");
    }
    else
    {
      showAlertDialog('Status', 'Problem Saving Note');
    }





  }

  void save() async
  {
    moveToLastScreen();

    int result;

    // var now = DateFormat.yMMMd().format(DateTime.now());
    var now = DateFormat.yMd().format(DateTime.now());
    print("now is $now");

    var title = titleController.text;
    var desc = descriptionController.text;

    result = await helper.insertData(title,desc,now);

    print("titile is ${title},desc ${desc}");
    
    if (result != 0)
    {
      showAlertDialog("Status", "Saved");
    }
    else
      {
        showAlertDialog('Status', 'Problem Saving Note');
      }


  }

  void showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }



}

