import 'package:anxeb_flutter/anxeb.dart' show Api;
import 'package:todo_app/models/primary/task.dart';

class TaskService {
  final String _tasksPath = '/tasks';

  Api api;

  TaskService(this.api);

  Future<List<TaskModel>> getTasks({Map<String, dynamic> queryString}) async {
    final result = await api.get(_tasksPath, queryString);
    final List<TaskModel> tasks = result.list((data) => TaskModel(data));

    return tasks.toList();
  }
}
