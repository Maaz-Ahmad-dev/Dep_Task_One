import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:dep_task_one/data/database.dart';
import 'package:dep_task_one/data/notifications.dart';
import 'package:dep_task_one/utils/dialogue_box.dart';
import 'package:dep_task_one/utils/edit_dialogue.dart';
import 'package:dep_task_one/utils/toDoTile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'dart:core';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool taskState = true;
  String Date = '.';
  final task_con = TextEditingController();
  final edit_con = TextEditingController();
  final _myBox = Hive.box("mybox");
  ToDoDatabase db = ToDoDatabase();
  NotificationService notificationService = NotificationService();

  //create a task
  void createTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogueBox(
            controller: task_con,
            onSave: saveFullTask,
            onCancel: () => Navigator.pop(context),
          );
        });
  }

  //save with date // id
  void saveFullTask() async {
    final res = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: DateTime.now(),
    );
    if (res == null) {
      return null;
    } else {
      final formater = DateFormat('yyyy-MM-dd');
      final id = DateFormat('MddHHmmss').format(res);
      DateTime notifyTime = res;
      setState(() {
        Date = formater.format(res);
        db.toDoList.add([task_con.text.toString(), false, Date, id]);
        NotificationService.scheduleNotification(
            int.parse(id), "Reminder", task_con.text.toString(), notifyTime);
        task_con.clear();
        final snackBar = SnackBar(
            content: Text(
                "Task Added Successfully.\nYou will be Reminded at ${notifyTime}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      Navigator.pop(context);
      db.update();
    }
  }

  //delete a task
  void deleteTask(int index) {
    setState(() {
      int id = int.parse(db.toDoList[index][3]);
      NotificationService.removeNotification(id);
      db.toDoList.removeAt(index);
    });
    final snackBar = SnackBar(content: Text("Task Deleted Successfully."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    db.update();
  }

  //on checkbox change
  void onCheckBoxChange(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      if (db.toDoList[index][1] == true)
        NotificationService.showNotification(
            "Task Completed", db.toDoList[index][0]);
    });
    db.update();
  }

  //update a task // notification Changed after five
  void updateFullTask(int index, String task) {
    showDialog(
        context: context,
        builder: (context) {
          return EditDialogue(
            task: task,
            controller: edit_con,
            onEdit: () async {
              final res = await showBoardDateTimePicker(
                context: context,
                pickerType: DateTimePickerType.datetime,
                initialDate: DateTime.now(),
              );
              if (res == null) {
                return null;
              } else {
                final formater = DateFormat('yyyy-MM-dd');
                final id = DateFormat('MddHHmmss').format(res);
                DateTime notifyTime = res;
                setState(() {
                  Date = formater.format(res);
                  db.toDoList[index][0] = edit_con.text.toString();
                  db.toDoList[index][2] = Date;
                  db.toDoList[index][3] = id;
                  // Updated notification
                  NotificationService.scheduleNotification(int.parse(id),
                      "Reminder", edit_con.text.toString(), notifyTime);
                  edit_con.clear();
                });
                final snackBar = SnackBar(
                    content: Text(
                        "Task Updated Successfully.\nYou will be Reminded at ${notifyTime}"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
                db.update();
              }
            },
            onCancel: () => Navigator.pop(context),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    edit_con.dispose();
    task_con.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          "To-Do App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createTask();
        },
        shape: CircleBorder(),
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 1),
                      color: taskState ? Colors.deepPurple : Colors.transparent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        taskState = true;
                      });
                    },
                    child: Text(
                      "Pending",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 1),
                      color: taskState ? Colors.transparent : Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        taskState = false;
                      });
                    },
                    child: Text(
                      "Completed",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: db.toDoList.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: db.toDoList[index][1] != taskState,
                      child: Todotile(
                        taskName: db.toDoList[index][0],
                        taskCompleted: db.toDoList[index][1],
                        dueDate: db.toDoList[index][2],
                        onChanged: (value) => onCheckBoxChange(value, index),
                        deleteTile: (context) => deleteTask(index),
                        updateTile: (context) =>
                            updateFullTask(index, db.toDoList[index][0]),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
