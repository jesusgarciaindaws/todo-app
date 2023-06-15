import 'package:anxeb_flutter/anxeb.dart' as anxeb;

class CredentialsModel extends anxeb.Model<CredentialsModel> {
  CredentialsModel([data]) : super(data);

  @override
  void init() {
    field(() => email, (v) => email = v, 'email');
    field(() => password, (v) => password = v, 'password');
  }

  bool any() => email != null && email.isNotEmpty;

  String email;
  String password;
}
