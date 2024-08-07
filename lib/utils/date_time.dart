import 'package:flutter/material.dart';

class DateTimePicker {
  Future<DateTime> showDateTime(BuildContext context) async {
    DateTime res = DateTime.now();
    await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 3652)))
        .then((date) {
      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((time) {
        res =
            DateTime(date!.year, date.month, date.day, time!.hour, time.minute);
      });
    });
    return res;
  }
}
