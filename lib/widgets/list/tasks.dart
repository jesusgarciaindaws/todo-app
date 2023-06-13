import 'package:flutter/material.dart';
import 'package:todo_app/models/primary/task.dart';

class ListTasks extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel) onSelectTask;

  const ListTasks({
    Key key,
    this.tasks,
    this.onSelectTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final Function(TaskModel) onSelectTask;

  const TaskTile({
    Key key,
    this.task,
    this.onSelectTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
