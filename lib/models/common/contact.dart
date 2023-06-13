import 'package:anxeb_flutter/anxeb.dart' as Anxeb;

class ContactModel extends Anxeb.Model<ContactModel> {
  ContactModel([data]) : super(data);

  @override
  void init() {
    field(() => name, (v) => name = v, 'name');
    field(() => phone, (v) => phone = v, 'phone');
    field(() => email, (v) => email = v, 'email');
  }

  String name;
  String phone;
  String email;
}
