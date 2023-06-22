import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/models/primary/task.dart';
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/services/task.dart';

class TaskHelper extends anxeb.ModelHelper<TaskModel> {
  Application get application => scope.application;

  TaskService get service => application.service.task;

  Future<TaskModel> fetch(
      {String id,
      Future Function(TaskHelper) success,
      Future Function(TaskHelper) next,
      bool silent}) async {
    if (silent != true) {
      await scope.busy(text: 'Cargando Tareas...');
    }

    try {
      final data = await scope.api.get('/tasks/${id ?? model.id}');
      scope.rasterize(() {
        model.update(data);
      });
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }

  Future<TaskModel> update(
      {Future Function(TaskHelper) success,
      Future Function(TaskHelper) next,
      bool silent}) async {
    if (silent != true) {
      await scope.busy(text: 'Actualizando Tarea...');
    }

    try {
      final data = await scope.api.post('/tasks', {'task': model.toObjects()});
      scope.rasterize(() {
        model.update(data);
      });
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }
}
