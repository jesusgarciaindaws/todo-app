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
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            onDeleteTask(task);
          },
          background: Container(
            color: Colors.red,
          ),
          child: Card(
            child: TaskTile(
              task: task,
              onSelectTask: onSelectTask,
            ),
          ),
        );
      },
    );
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
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description),
      onTap: () => onSelectTask(task),
    );
  }
}
