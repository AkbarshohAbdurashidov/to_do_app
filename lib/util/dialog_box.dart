// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 150, sigmaY: 15),

      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        shadowColor: Colors.greenAccent,
        backgroundColor: Colors.grey[900],
        
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                autofocus: true,
                cursorColor: Colors.greenAccent,
                controller: controller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                     
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "Add A new task *",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp('sex'),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Save button
                  MyButton(
                    text: "Save",
                    onPressed: onSave,
                  ),
                  // Cancel button
                  MyButton(
                    text: "Cancel",
                    onPressed: onCancel,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
