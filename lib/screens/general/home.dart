import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/screens/landing/about.dart';
import 'package:todo_app/screens/general/profile.dart';
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/middleware/session.dart';
import 'package:todo_app/models/primary/task.dart';
import 'package:todo_app/services/task.dart';
import 'package:todo_app/widgets/list/tasks.dart';
import 'package:todo_app/widgets/providers/scope.dart';

class HomeScreen extends Anxeb.ScreenWidget {
  HomeScreen({
    Key key,
  }) : super(
          'home',
          title: 'Nodrix',
          key: key,
        );

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends Anxeb.ScreenView<HomeScreen, Application> {
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
    return Anxeb.ScreenNavigator(
      scope: scope,
      roles: () => session.roles != null
          ? session.roles.map((e) => e.toString().split('.')[1]).toList()
          : ['any'],
      header: () => Anxeb.UserBlock(
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
        Anxeb.MenuGroup(
          caption: () => 'Inicio',
          key: 'home',
          icon: Anxeb.FontAwesome.home,
          home: true,
        ),
        Anxeb.MenuGroup(
          caption: () => 'Mi Perfil',
          key: 'profile',
          icon: Anxeb.FontAwesome5.user_cog,
          iconScale: 0.82,
          iconVOffset: 5,
          onTab: () async => push(ProfileScreen()),
        ),
        Anxeb.MenuGroup(
          caption: () => 'Acerca',
          key: 'about',
          icon: Icons.info,
          onTab: () async => push(AboutScreen()),
        ),
        Anxeb.MenuGroup(
          caption: () => 'Ir al Lobby',
          key: 'lobby',
          icon: Icons.stay_primary_landscape_sharp,
          divider: true,
          onTab: () async {
            application.exit(context);
          },
        ),
        Anxeb.MenuGroup(
          caption: () => 'Cerrar Sesión',
          key: 'logout',
          icon: Anxeb.CommunityMaterialIcons.door_open,
          iconVOffset: 2,
          onTab: () async {
            if (await scope.dialogs
                .confirm('¿Estás seguro que quieres terminar la sesión?')
                .show()) {
              try {
                await session.close();
                application.exit(context);
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
  Anxeb.ActionsHeader header() {
    return Anxeb.SearchHeader(
        scope: scope,
        submitDelay: () => 150,
        onBegin: () async {},
        onClear: _onClear,
        onSearch: _onSearch,
        onCompleted: _onCompleteSearch);
  }

  @override
  Anxeb.ScreenRefresher refresher() {
    return Anxeb.ScreenRefresher(
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
      return Anxeb.EmptyBlock(
        scope: scope,
        message: 'Cargando tareas ...',
        icon: Icons.sync,
      );
    }

    if (tasks == null) {
      return Anxeb.EmptyBlock(
        scope: scope,
        message: 'Error cargando tareas',
        icon: Icons.cloud_off,
        actionText: 'Refrescar',
        actionCallback: () async => _refresh(),
      );
    }

    if (tasks.isEmpty) {
      return Anxeb.EmptyBlock(
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
      ),
    );
  }

  void _onSelectTask(TaskModel task) async {}

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
