import 'package:anxeb_flutter/anxeb.dart';
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
      trailing: CheckboxTarea(
        task: task,
        onSelectTask: onSelectTask,
      ),
      onTap: () => onSelectTask(task),
    );
  }
}

class CheckboxTarea extends StatefulWidget {
  final TaskModel task;
  final Function(TaskModel) onSelectTask;

  const CheckboxTarea({Key key, this.task, this.onSelectTask})
      : super(key: key);

  @override
  State<CheckboxTarea> createState() => _CheckboxTarea();
}

class _CheckboxTarea extends State<CheckboxTarea> {
  ScreenScope scope;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueGrey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.task == null,
      onChanged: (bool value) {
        widget.onSelectTask(widget.task);
      },
    );
  }
}
