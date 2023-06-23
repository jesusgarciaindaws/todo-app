import 'package:anxeb_flutter/middleware/api.dart';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/screens/landing/about.dart';
import 'package:todo_app/screens/general/profile.dart';
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/middleware/session.dart';
import 'package:todo_app/models/primary/task.dart';
import 'package:todo_app/services/task.dart';
import 'package:todo_app/widgets/list/tasks.dart';
import 'package:todo_app/widgets/providers/scope.dart';
import 'package:todo_app/forms/task.dart';

class HomeScreen extends anxeb.ScreenWidget {
  HomeScreen({
    Key key,
  }) : super(
          'home',
          title: 'Nodrix',
          key: key,
        );

  @override
  anxeb.ScreenView<HomeScreen, Application> createState() => _HomeState();
}

class _HomeState extends anxeb.ScreenView<HomeScreen, Application> {
  TaskService _taskService;
  List<TaskModel> _tasks = [];
  List<TaskModel> _tasksFiltered = [];
  bool _refreshing;

  @override
  void setup() {
    _taskService = TaskService(scope.api);

    application.overlay.navigationFill = application.settings.colors.navigation;
    application.overlay.extendBodyFullScreen = false;
    application.overlay.brightness = Brightness.dark;
    application.overlay.apply(instant: true);
  }

  @override
  Future init() async {
    _refresh();
  }

  @override
  Future closing() async {
    application.unload();
  }

  @override
  Future closed() async {
    Navigator.of(context).pushNamed('/lobby');
  }

  @override
  Widget drawer() {
    return anxeb.ScreenNavigator(
      scope: scope,
      roles: () => session.roles != null
          ? session.roles.map((e) => e.toString().split('.')[1]).toList()
          : ['any'],
      header: () => anxeb.UserBlock(
        safeArea: true,
        background: const AssetImage('assets/images/common/admin-drawer.png'),
        imageUrl:
            application.api.getUri('/storage/profile/avatar?t=${session.tick}'),
        color: const Color(0xffffdc54),
        authToken: application.api.token,
        userName: session?.user?.lightName ?? '',
        userTitle: session?.user?.login?.email ?? '',
        onTab: () {
          push(ProfileScreen());
        },
      ),
      groups: () => [
        anxeb.MenuGroup(
          caption: () => 'Inicio',
          key: 'home',
          icon: anxeb.FontAwesome.home,
          home: true,
        ),
        anxeb.MenuGroup(
          caption: () => 'Mi Perfil',
          key: 'profile',
          icon: anxeb.FontAwesome5.user_cog,
          iconScale: 0.82,
          iconVOffset: 5,
          onTab: () async => push(ProfileScreen()),
        ),
        anxeb.MenuGroup(
          caption: () => 'Acerca',
          key: 'about',
          icon: Icons.info,
          onTab: () async => push(AboutScreen()),
        ),
        anxeb.MenuGroup(
          caption: () => 'Ir al Lobby',
          key: 'lobby',
          icon: Icons.stay_primary_landscape_sharp,
          divider: true,
          onTab: () async {
            application.exit(context);
          },
        ),
        anxeb.MenuGroup(
          caption: () => 'Cerrar Sesión',
          key: 'logout',
          icon: anxeb.CommunityMaterialIcons.door_open,
          iconVOffset: 2,
          onTab: () async {
            if (await scope.dialogs
                .confirm('¿Estás seguro que quieres terminar la sesión?')
                .show()) {
              try {
                await session.close();
                if (context.mounted) {
                  application.exit(context);
                }
                scope.rasterize();
              } catch (err) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  scope.alerts.error(err).show();
                });
              }
            }
          },
        )
      ],
    );
  }

  @override
  anxeb.ActionsHeader header() {
    return anxeb.SearchHeader(
        scope: scope,
        submitDelay: () => 150,
        onBegin: () async {
          _refresh();
        },
        onClear: _onClear,
        onSearch: _onSearch,
        onCompleted: _onCompleteSearch);
  }

  @override
  anxeb.ScreenRefresher refresher() {
    return anxeb.ScreenRefresher(
      scope: scope,
      action: () async => _refresh(),
      onError: (err) => scope.alerts.error(err).show(),
    );
  }

  @override
  Widget content() {
    return _getContentList(tasks);
  }

  Future<List<TaskModel>> _getTasks() async {
    List<TaskModel> tasks = [];
    await scope.busy();
    try {
      tasks = await _taskService.getTasks();
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      await scope.idle();
    }

    return tasks;
  }

  Future _refresh() async {
    rasterize(() {
      _refreshing = true;
    });

    _tasks = _tasksFiltered = await _getTasks();

    rasterize(() {
      _refreshing = false;
    });
  }

  Widget _getContentList(List<TaskModel> tasks) {
    if (tasks == null && _refreshing == true) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'Cargando tareas ...',
        icon: Icons.sync,
      );
    }

    if (tasks == null) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'Error cargando tareas',
        icon: Icons.cloud_off,
        actionText: 'Refrescar',
        actionCallback: () async => _refresh(),
      );
    }

    if (tasks.isEmpty) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'No tiene tareas',
        icon: Icons.task_rounded,
        actionText: 'Refrescar',
        actionCallback: _refresh,
      );
    }

    return ScopeProvider(
      scope: scope,
      child: ListTasks(
        tasks: tasks,
        onSelectTask: _onSelectTask,
        onDeleteTask: _onDeleteTask,
      ),
    );
  }

  void _onSelectTask(TaskModel task) async {
    task.using(scope).fetch(success: (helper) async {
      final form = TaskForm(scope: scope, task: task);
      await form.show();
      // if (result != null && result.$deleted == true) {
      //   rasterize(() {
      //     _tasks.remove(task);
      //   });
      // }
    });
  }

  void _onDeleteTask(TaskModel task) async {
    try {
      await scope.api.delete('/tasks/${task.id}');
      _refresh();
    } catch (err) {
      scope.alerts.error(err).show();
    }
  }

  Future _onSearch(String text) async {
    if (text.isNotEmpty) {
      try {
        final results = _tasks.where((e) => e.id.startsWith(text))?.toList();
        rasterize(() {
          _tasksFiltered = results ?? [];
        });
      } catch (err) {
        scope.alerts.error(err).show();
      }
    }
  }

  Future _onCompleteSearch(String text) async {
    _onClear();
  }

  Future _onClear() async {
    rasterize(() {
      _tasksFiltered = _tasks;
    });
  }

  Session get session => application.session;

  List<TaskModel> get tasks => _tasksFiltered;
}
