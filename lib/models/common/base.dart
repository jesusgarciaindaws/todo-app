import 'package:anxeb_flutter/anxeb.dart' as Anxeb;

class BaseModel extends Anxeb.Model<BaseModel> {
  BaseModel([data]) : super(data);

  @override
  void init() {
    field(() => id, (v) => id = v, 'id', primary: true);
    field(() => name, (v) => name = v, 'name');
  }

  String id;
  String name;

  String get nameLower => name?.toLowerCase() ?? '';
}
