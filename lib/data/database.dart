import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];
  // referrence of hive box
  final _myBox = Hive.box("mybox");

  //Create initial data
  void createInitialData() {
    toDoList = [
      ['Welcome to To-Do App', false, '.', '1'],
      ['Create your daiy Tasks', false, '.', '1']
    ];
  }

  //load data from db
  void load() {
    toDoList = _myBox.get("TODOLIST");
  }

  //update the db
  void update() {
    _myBox.put("TODOLIST", toDoList);
  }
}
