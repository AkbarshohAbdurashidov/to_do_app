// ignore_for_file: unused_field, unnecessary_null_comparison

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final _myBox = Hive.box('myBox');

  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // if data not empty
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      db.updateDatabase();
    });
  }

  void saveNewTask() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        db.toDoList.add([_controller.text, false]);
        db.updateDatabase();
        Navigator.of(context).pop();
      } else {
        const snackBar = SnackBar(
          backgroundColor: Colors.greenAccent,
          elevation: 10,
          showCloseIcon: true,
          closeIconColor: Colors.red,
          content: Text(
            'The field cannot be empty!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    });
    _controller.clear();
  }

  void createNewTask({int? index}) {
    if (index != null) {
      _controller.text = db.toDoList[index][0];
    } else {
      _controller.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            if (index != null) {
              _editTask(index);
            } else {
              saveNewTask();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void _editTask(int index) {
    setState(() {
      if (_controller.text.isNotEmpty) {
        db.toDoList[index][0] = _controller.text;
        Navigator.of(context).pop();
      }
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 200, sigmaY: 15),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text(
          "TO  DO",
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black38,
        onPressed: () => createNewTask(),
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.greenAccent,
        ),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            onChanged: (value) => checkBoxChanged(value, index),
            taskCompleted: db.toDoList[index][1],
            taskName: db.toDoList[index][0],
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) => createNewTask(index: index),
          );
        },
      ),
    );
  }
}
