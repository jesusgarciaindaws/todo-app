import 'package:flutter/material.dart';
import 'package:todo_app/middleware/global.dart';
import 'package:todo_app/models/primary/task.dart';
import 'package:http/http.dart' as http;

class ListTasks extends StatefulWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel) onSelectTask;

  const ListTasks({
    Key key,
    this.tasks,
    this.onSelectTask,
  }) : super(key: key);

  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  void deleteTask(TaskModel task) async {
    try {
      await http
          .delete(Uri.parse('${Global.settings.apiUrl}/tasks/${task.id}'));
      setState(() {
        widget.tasks.remove(task);
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = widget.tasks[index];
        return Card(
          child: TaskTile(
            task: task,
            onSelectTask: widget.onSelectTask,
            onDeleteTask: deleteTask,
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
