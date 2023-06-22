import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/middleware/global.dart';
import 'package:todo_app/models/primary/task.dart';

class TaskForm extends anxeb.FormDialog<TaskModel, Application> {
  TaskModel _task;

  TaskForm({@required anxeb.Scope scope, TaskModel task})
      : super(
          scope,
          model: task,
          dismissable: true,
          title: task == null ? 'Nueva Tarea' : 'Editar Tarea',
          subtitle: task?.name,
          icon:
              task == null ? Icons.add : anxeb.CommunityMaterialIcons.file_edit,
          width: double.maxFinite,
        );

  @override
  void init(anxeb.FormScope scope) {
    _task = TaskModel();
    _task.update(model);
  }

  @override
  Widget body(anxeb.FormScope scope) {
    return Column(
      children: [
        anxeb.FormRowContainer(
          scope: scope,
          fields: [
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'name',
                group: 'task',
                icon: Icons.text_fields,
                fetcher: () => _task.name,
                label: 'Nombre',
                type: anxeb.TextInputFieldType.text,
                validator: anxeb.Utils.validators.nada,
                applier: (value) => _task.name = value,
                autofocus: true,
              ),
            ),
            anxeb.FormSpacer(),
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'description',
                group: 'task',
                icon: Icons.text_fields,
                fetcher: () => _task.description,
                label: 'Descipcion',
                type: anxeb.TextInputFieldType.text,
                validator: anxeb.Utils.validators.nada,
                applier: (value) => _task.description = value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  List<anxeb.FormButton> buttons(anxeb.FormScope<Application> scope) {
    return [
      anxeb.FormButton(
        caption: 'Guardar',
        onTap: (anxeb.FormScope scope) => _persist(scope),
        icon: Icons.check,
      ),
    ];
  }

  Future _persist(anxeb.FormScope scope) async {
    final form = scope.forms['task'];
    if (form.valid(autoFocus: true)) {
      await _task.using(scope.parent).update(success: (helper) async {
        if (exists) {
          scope.parent.alerts.success('tarea actualizada exitosamente').show();
          scope.parent.rasterize(() {
            model.update(_task);
          });
        } else {
          scope.parent.alerts.success('tarea creada exitosamente').show();
        }
      });
    }
  }

  @override
  Future Function(anxeb.FormScope scope) get close => (scope) async => true;
}
