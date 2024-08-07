import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todotile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String dueDate;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteTile;
  final Function(BuildContext)? updateTile;
  const Todotile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.dueDate,
    required this.onChanged,
    required this.deleteTile,
    required this.updateTile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: updateTile,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.blue.shade300,
            ),
            SlidableAction(
              onPressed: deleteTile,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.red.shade300,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              VerticalDivider(
                color: taskCompleted ? Colors.deepPurple : Colors.white,
                thickness: 5,
              ),
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.deepPurple,
                checkColor: Colors.white,
              ),
              Expanded(
                  child: Text(
                taskName,
                overflow: TextOverflow.ellipsis,
                maxLines: 200,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.deepPurple,
                    decorationThickness: 2),
              )),
              Text(
                dueDate,
                style: TextStyle(color: Colors.white38),
              ),
              SizedBox(
                width: 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
