import 'package:anxeb_flutter/anxeb.dart' as Anxeb;

class CorporateModel extends Anxeb.Model<CorporateModel> {
  CorporateModel([data]) : super(data);

  @override
  void init() {
    field(() => phone, (v) => phone = v, 'phone');
    field(() => fax, (v) => fax = v, 'fax');
    field(() => email, (v) => email = v, 'email');
    field(() => website, (v) => website = v, 'website');
  }

  String phone;
  String fax;
  String email;
  String website;
}
