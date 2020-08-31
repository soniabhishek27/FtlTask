// import 'package:ftltask/main.dart';
// import 'package:intl/intl.dart';
//
//
// class ToDoHelperClass
// {
//   int _id;
//   String _title;
//   String _description;
//   String _date;
//
//
//
//   ToDoHelperClass(this._title, this._description, this._date);
//
//
//
//   int get id => _id;
//
//   String get title => _title;
//   String get description => _description;
//   String get date => _date;
//
//
//
//
//   set title(String newTitle) {
//     if (newTitle.length <= 255) {
//       this._title = newTitle;
//     }
//   }
//
//   set description(String newDescription) {
//     if (newDescription.length <= 255) {
//       this._description = newDescription;
//     }
//   }
//
//   set date(String newDate)
//   {
//     this._date = DateFormat.yMMMd().format(DateTime.now());
//
//     // this._date = newDate;
//   }
//
//
// // Convert a ToDo object into a Map object
//
// Map<String,dynamic> toMap()
//   {
//     var map = Map<String,dynamic>();
//
//     if (id != null)
//     {
//       map['id'] = _id;
//     }
//
//     map['title'] = _title;
//     map['description'] = _description;
//     map['date'] = _date;
//
//     return map;
//   }
//
// // Extract a ToDo object from a Map object
//
//   ToDoHelperClass.fromMapObject(Map<String, dynamic> map)
//   {
//     this._id = map['id'];
//     this._title = map['title'];
//     this._description = map['description'];
//     this._date = map['date'];
//
//   }
//
//
//
//
//
// }

class ToDoHelperClass
{

  var id;
  var title;
  var description;
  var date;

  ToDoHelperClass(this.id,this.title, this.description, this.date);


  Map<String, dynamic> toMap()
  {

    var map = Map<String, dynamic>();
    if (id != null)
    {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;

    return map;
  }

}