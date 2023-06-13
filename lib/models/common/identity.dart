import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/middleware/global.dart';

class IdentityModel extends Anxeb.Model<IdentityModel> {
  IdentityModel([data]) : super(data);

  @override
  void init() {
    field(() => type, (v) => type = v, 'type', enumValues: IdentityType.values);
    field(() => number, (v) => number = v, 'number');
  }

  @override
  String toString() {
    if (type == null || number == null) {
      return null;
    }
    return '${Global.captions.identityCaption(type)}: $number';
  }

  IdentityType type;
  String number;
}

enum IdentityType { passport, license, personal, company }
