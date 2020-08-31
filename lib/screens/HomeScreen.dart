import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:ftltask/constants/Animation.dart';
import 'package:ftltask/models/ToDo.dart';
import 'package:ftltask/screens/OperationsScreen.dart';
import 'package:ftltask/screens/ToDoDetails.dart';
import 'package:ftltask/utils/Database_Helper.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';




class HomeScreen extends StatefulWidget
{
  static String id = 'homeScreen';



  @override
  State<StatefulWidget> createState()
  {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {

  static var deletedTitle;
  static var deletedDesc;
  static var deletedDate;

  DatabaseHelper databaseHelper = DatabaseHelper();

  List<ToDoHelperClass> todoList;

  int count = 0;

  Future<List<ToDoHelperClass>> myInit() async {
    DatabaseHelper databaseHelper = DatabaseHelper();

    todoList.clear();

    var allData = await databaseHelper.getAllMapList();

    for (int i = 0; i < allData.length; i++) {
      try {
        ToDoHelperClass toDoHelperClass = ToDoHelperClass(
          allData[i]['id'],
          allData[i]['title'],
          allData[i]['description'],
          allData[i]['date'],
        );

        todoList.add(toDoHelperClass);

        setState(() {
          print("lenght is: ${todoList.length}");
        });
      } catch (e) {
        print(e);
      }
    }

    return todoList;
  }

  @override
  void initState() {
    super.initState();

    // myInit();
  }

  @override
  Widget build(BuildContext context) {
    // updateListView();

    if (todoList == null) {
      todoList = List<ToDoHelperClass>();
      updateListView();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('To Do'),
      ),
      body: count == 0
          ? Animations()
          : ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print("Tapped on ${todoList[index].title}");
                    
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ToDoDetails(
                        todoList[index].title,
                        todoList[index].description,

                      )
                    ));



                  },
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(todoList[index].title),
                    onDismissed: (direction)
                    {

                      deletedTitle = todoList[index].title;
                      deletedDesc = todoList[index].description;
                      deletedDate = todoList[index].date;

                      delete(context, todoList[index]);
                    },
                    background: Container(color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(left: 300.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete,
                            color: Colors.white,
                          ),
                          Text('Delete',
                          style: TextStyle(
                            color: Colors.white
                          ),)
                        ],

                      ),
                    ),

                    ),
                    child: Card(
                      child: ListTile(
                        leading: IconButton(
                          onPressed: ()
                          {

                            navigateToDetail(ToDoHelperClass(todoList[index].id,todoList[index].title,todoList[index].description,""), "Edit");


                          },
                          icon: Icon(Icons.edit)
                        ),
                        title: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Text(
                            '${this.todoList[index].title}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: AutoSizeText(
                                  "${todoList[index].date}",
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: Text(
                                  "   ${this.todoList[index].description},",
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: GestureDetector(
                          child: Icon(Icons.delete),
                          onTap: () {
                            delete(context, todoList[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                );

              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(ToDoHelperClass('','','',''),"Add");
        },
        tooltip: 'Add To Do',
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToDetail(ToDoHelperClass todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context)
        {
      return OperationsScreen(todo,title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    DatabaseHelper databaseHelper = DatabaseHelper();

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ToDoHelperClass>> todoListFuture = myInit();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;

          print("count is $count");
        });
      });
    });
  }

  void delete(BuildContext context, ToDoHelperClass todo) async
  {
    int result = await databaseHelper.deleteData(todo.id);
    print(todo.id);

    if (result != 0)
    {
      showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void showSnackBar(BuildContext context, String message)
  {
    final snackBar = SnackBar(
        content: Text(message),
            action: SnackBarAction(
        label: "UNDO",
      onPressed: ()
      {
        var result = databaseHelper.insertData(deletedTitle, deletedDesc, deletedDate);

        if (result != 0)
        {
          updateListView();

        }

      },
    ),


    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
