import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anxeb_flutter/anxeb.dart' show Api, Data;
import 'package:todo_app/models/primary/task.dart';
import 'package:todo_app/services/task.dart';

class ApiMock extends Mock implements Api {}

void main() {
  group('Task service', () {
    ApiMock api;

    setUp(() {
      api = ApiMock();
    });

    test('Should load units', () async {
      final taskService = TaskService(api);

      when(api.get(any, any)).thenAnswer(
        (_) async => Data([TaskModel()]),
      );

      final List<TaskModel> tasks = await taskService.getTasks();

      verify(api.get(any, any));
      expect(tasks.length, equals(1));
    });
  });
}
