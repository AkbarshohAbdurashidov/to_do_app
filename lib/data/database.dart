// ignore_for_file: unused_field

import 'package:hive/hive.dart';

class ToDoDataBase {
  List toDoList = [];
// referencce our box
  final _myBox = Hive.box('myBox');

// run this method if this is the 1st time ever opaning this app
  void createInitialData() {
    toDoList = [
      ["Make tutorial", false],
      ["Do exercise", false]
    ];
  }

  // load data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  // update database
  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
