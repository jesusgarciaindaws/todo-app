import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'auth.dart';

class ConfigurationModel extends anxeb.Model<ConfigurationModel> {
  ConfigurationModel([data]) : super(data);

  ConfigurationModel.fromDisk(
      [anxeb.ModelLoadedCallback<ConfigurationModel> callback])
      : super.fromDisk('credentials', callback);

  @override
  void init() {
    field(() => auth, (v) => auth = v, 'auth',
        instance: (data) => data != null ? SessionAuth(data) : null);
    field(() => language, (v) => language = v, 'language', defect: () => 'es');
  }

  SessionAuth auth;

  String language;

  bool get isAuthSaved => auth?.user?.login?.email?.isNotEmpty == true;
}
