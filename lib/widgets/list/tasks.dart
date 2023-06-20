import 'package:flutter/material.dart';
import 'package:todo_app/models/primary/task.dart';

class ListTasks extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel) onSelectTask;
  final Function(TaskModel) onDeleteTask;

  const ListTasks({
    Key key,
    this.tasks,
    this.onSelectTask,
    this.onDeleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = tasks[index];
        return Card(
          child: TaskTile(
            task: task,
            onSelectTask: onSelectTask,
            onDeleteTask: onDeleteTask,
          ),
        );
      },
    );
  }
}

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final Function(TaskModel) onSelectTask;
  final Function(TaskModel) onDeleteTask;

  const TaskTile({
    Key key,
    this.task,
    this.onSelectTask,
    this.onDeleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description),
      trailing: IconButton(
        onPressed: () => onDeleteTask(task),
        icon: const Icon(Icons.delete),
        color: Colors.pink,
      ),
    );
  }
}
