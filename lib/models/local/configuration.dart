import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'auth.dart';

class ConfigurationModel extends Anxeb.Model<ConfigurationModel> {
  ConfigurationModel([data]) : super(data);

  ConfigurationModel.fromDisk(
      [Anxeb.ModelLoadedCallback<ConfigurationModel> callback])
      : super.fromDisk('credentials', callback);

  @override
  void init() {
    field(() => auth, (v) => auth = v, 'auth',
        instance: (data) => data != null ? SessionAuth(data) : null);
    field(() => language, (v) => language = v, 'language', defect: () => 'es');
  }

  SessionAuth auth;

  String language;

  bool get isAuthSaved => auth?.member?.login?.email?.isNotEmpty == true;
}
