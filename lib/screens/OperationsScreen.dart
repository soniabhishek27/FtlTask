import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:ftltask/models/ToDo.dart';
import 'package:ftltask/screens/HomeScreen.dart';
import 'package:ftltask/utils/Database_Helper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:intl/intl.dart';
import 'package:ftltask/constants/MyButton.dart';

//this class performa all the crud operations and includes Business logic

class OperationsScreen extends StatefulWidget
{
  static String id = 'OperationsScreen';
  final String appBarTitle;
  final ToDoHelperClass todo;

  OperationsScreen(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState()
  {
    return _OperationsScreenState(this.todo, this.appBarTitle);
  }
}

class _OperationsScreenState extends State<OperationsScreen>
{
  DatabaseHelper helper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();

  stt.SpeechToText _speech;
  bool isListening = false;
  bool isListening2 = false;


  String text = "Press the button and Start Speaking";

  String appBarTitle;
  ToDoHelperClass todo;

  _OperationsScreenState(this.todo, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    if (appBarTitle == 'Edit') {
      titleController.text = todo.title;
      descriptionController.text = todo.description;
    }

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
                  icon: Icon(
                    Icons.keyboard_voice,
                    size: 35.0,
                    color: isListening2 == true ? Colors.red : Colors.black,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextFormField(
                      validator: (value) {
                        return value.isEmpty ? 'Title is required' : null;
                      },
                      maxLines: 1,
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
              ],
            ),

            //Description
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    listen();
                  },
                  icon: Icon(
                    Icons.keyboard_voice,
                    size: 35.0,
                    color: isListening == true ? Colors.red : Colors.black,
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
                      maxLines: 5,
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint(
                            'Something changed in Description Text Field');
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10.0,
            ),
            if (appBarTitle == 'Add')
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: MyButton(
                          colour: Colors.blue,
                          title: 'Save',
                          onPressed: () {
                            print("saved");
                                  save();
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                  ],
                ),
              )
            else
              MyButton(
                colour: Colors.blue,
                title: 'Update',
                onPressed: ()
                {
                  update();
                },
              ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen()
  {
    Navigator.pop(context, true);
    // Navigator.pushNamed(context, HomeScreen.id);
  }

  void listen() async {
    if (!isListening) {
      print("Inside if 1");
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus $val'),
        onError: (val) => print('onError $val'),
      );
      if (available) {
        print("Inside if 2");

        setState(() {
          isListening = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            text = val.recognizedWords;
            descriptionController.value = descriptionController.value.copyWith(
              text: text,
              selection: TextSelection(
                  baseOffset: text.length, extentOffset: text.length),
              composing: TextRange.empty,
            );

            // isListening = false;
          });
        });
      }
    } else {
      setState(() {
        isListening = false;
        _speech.stop();
      });
      print("NI else part");
    }
  }
  void listen2() async {
    if (!isListening2) {
      print("Inside if 1");
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus $val'),
        onError: (val) => print('onError $val'),
      );
      if (available) {
        print("Inside if 2");

        setState(() {
          isListening2 = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            text = val.recognizedWords;
            titleController.value = titleController.value.copyWith(
              text: text,
              selection: TextSelection(
                  baseOffset: text.length, extentOffset: text.length),
              composing: TextRange.empty,
            );

            // isListening = false;
          });
        });
      }
    } else {
      setState(() {
        isListening2 = false;
        _speech.stop();
      });
      print("NI else part");
    }
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  // Update the description of Todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  void update() async {
    moveToLastScreen();

    int result;

    var id = todo.id;
    var title = titleController.text;
    var desc = descriptionController.text;

    result = await helper.updateData(title, desc, id);

    if (result != 0) {
      showAlertDialog("Status", "Entry Updated Successfully");
    } else {
      showAlertDialog('Status', 'Problem Saving Entry');
    }
  }

  void save() async {
    moveToLastScreen();

    int result;

    // var now = DateFormat.yMMMd().format(DateTime.now());
    var now = DateFormat.yMd().format(DateTime.now());
    print("now is $now");

    var title = titleController.text;
    var desc = descriptionController.text;

    result = await helper.insertData(title, desc, now);

    print("titile is ${title},desc ${desc}");

    if (result != 0) {
      showAlertDialog("Status", "Saved");
    } else {
      showAlertDialog('Status', 'Problem Saving Entry');
    }
  }

  void showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
