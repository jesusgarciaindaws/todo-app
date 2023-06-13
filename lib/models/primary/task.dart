import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/helpers/task.dart';

class TaskModel extends Anxeb.HelpedModel<TaskModel, TaskHelper> {
  TaskModel([data]) : super(data);

  @override
  void init() {
    field(() => id, (v) => id = v, 'id', primary: true);
    field(() => name, (v) => name = v, 'name');
    field(() => description, (v) => description = v, 'description');
  }

  String id;
  String name;
  String description;

  @override
  TaskHelper helper() => TaskHelper();

  String get fullName => name;
}
