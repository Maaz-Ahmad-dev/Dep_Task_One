import 'package:dep_task_one/utils/buttons.dart';
import 'package:flutter/material.dart';

class EditDialogue extends StatelessWidget {
  final controller;
  final String task;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  const EditDialogue(
      {super.key,
      required this.task,
      required this.controller,
      required this.onEdit,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    controller.text = task;
    return AlertDialog(
      backgroundColor: Colors.deepPurple.shade400,
      title: Text("Update"),
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
                        onEdit();
                      }
                    },
                    text: "Edit")
              ],
            )
          ],
        ),
      ),
    );
  }
}
