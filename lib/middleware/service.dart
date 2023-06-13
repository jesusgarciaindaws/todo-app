import 'package:anxeb_flutter/anxeb.dart' show Api;
import 'package:todo_app/services/task.dart';

class Service {
  Api api;

  TaskService task;

  Service(this.api) {
    task = TaskService(api);
  }
}
