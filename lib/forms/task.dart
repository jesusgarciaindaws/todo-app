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
          nueva: task == null,
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
          ],
        ),
        anxeb.FormRowContainer(
          scope: scope,
          fields: [
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
        caption: 'Crear',
        visible: !exists,
        onTap: (anxeb.FormScope scope) => _create(scope),
        fillColor: scope.application.settings.colors.success,
        icon: Icons.create,
        rightDivisor: true,
      ),
      anxeb.FormButton(
        caption: 'Guardar',
        visible: exists,
        onTap: (anxeb.FormScope scope) => _persist(scope),
        icon: Icons.check,
      ),
      anxeb.FormButton(
        caption: 'Cancelar',
        onTap: (anxeb.Scope scope) async => true,
        icon: Icons.close,
      )
    ];
  }

  Future _persist(anxeb.FormScope scope) async {
    final form = scope.forms['task'];
    if (form.valid(autoFocus: true)) {
      await _task.using(scope.parent).update(success: (helper) async {
        scope.parent.alerts.success('tarea actualizada exitosamente').show();
        scope.parent.rasterize(() {
          model.update(_task);
        });
      });
    }
  }

  Future _create(anxeb.FormScope scope) async {
    final form = scope.forms['task'];
    if (form.valid(autoFocus: true)) {
      await _task.using(scope.parent).insert(success: (helper) async {
        scope.parent.alerts.success('tarea creada exitosamente').show();
      });
    }
  }

  @override
  Future Function(anxeb.FormScope scope) get close => (scope) async => true;
}
