import 'package:flutter/material.dart';
import 'package:anxeb_flutter/middleware/scope.dart';

class ScopeProvider extends InheritedWidget {
  final Scope scope;

  const ScopeProvider({
    @required this.scope,
    @required Widget child,
    Key key,
  })  : assert(scope != null),
        assert(child != null),
        super(key: key, child: child);

  static ScopeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScopeProvider>();
  }

  @override
  bool updateShouldNotify(ScopeProvider oldWidget) => false;
}
