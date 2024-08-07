import 'package:dep_task_one/utils/buttons.dart';
import 'package:flutter/material.dart';

class DialogueBox extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const DialogueBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return AlertDialog(
      backgroundColor: Colors.deepPurple.shade400,
      title: Text(
        "Add a Task",
        style: TextStyle(color: Colors.white),
      ),
      content: Container(
        alignment: Alignment.center,
        height: 190,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.black)),
                  hintText: "What is in your mind??",
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5), fontSize: 12),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please write anything";
                  } else
                    return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Buttons(onpressed: onCancel, text: "Cancel"),
                const SizedBox(
                  width: 5,
                ),
                Buttons(
                    onpressed: () {
                      if (formkey.currentState!.validate()) {
                        onSave();
                      }
                    },
                    text: "Add")
              ],
            )
          ],
        ),
      ),
    );
  }
}
