import 'package:anxeb_flutter/anxeb.dart' as anxeb;

class PeriodModel extends anxeb.Model<PeriodModel> {
  PeriodModel([data]) : super(data);

  @override
  void init() {
    field(() => year, (v) => year = v, 'year');
    field(() => month, (v) => month = v, 'month');
  }

  int year;
  int month;
}
