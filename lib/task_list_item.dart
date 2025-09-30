// task_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/task_model.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(bool?) onToggleCompleted;
  final VoidCallback onTap;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onToggleCompleted,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1D1D),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onToggleCompleted,
                activeColor: const Color(0xFF8875FF),
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        decorationColor: Colors.white54,
                      ),
                    ),
                    if (task.date != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          DateFormat('dd MMM, HH:mm').format(task.date!),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  if (task.category != null)
                    Chip(
                      label: Text(task.category!),
                      backgroundColor: const Color(0xFF8875FF).withOpacity(0.2),
                      labelStyle: const TextStyle(color: Color(0xFF8875FF)),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  const SizedBox(width: 8),
                  if (task.priority != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8875FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flag_outlined, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text('${task.priority}', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
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