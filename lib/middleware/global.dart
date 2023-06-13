import 'package:todo_app/global/captions.dart';
import 'package:todo_app/global/colors.dart';
import 'package:todo_app/global/faddings.dart';
import 'package:todo_app/global/gradients.dart';
import 'package:todo_app/global/icons.dart';
import 'package:todo_app/global/paddings.dart';
import 'package:todo_app/global/settings.dart';
import 'package:todo_app/global/shadows.dart';
import 'package:todo_app/global/styles.dart';
import 'package:todo_app/global/validators.dart';

class Global {
  static final Global _singleton = Global._internal(
    const bool.fromEnvironment('dart.vm.product'),
  );
  static GlobalColors colors = GlobalColors();
  static GlobalStyles styles = GlobalStyles();
  static GlobalPaddings paddings = GlobalPaddings();
  static GlobalFaddings faddings = GlobalFaddings();
  static GlobalGradients gradients = GlobalGradients();
  static GlobalSettings settings = GlobalSettings(
    const String.fromEnvironment('mode'),
  );
  static GlobalShadows shadows = GlobalShadows();
  static GlobalCaptions captions = GlobalCaptions();
  static GlobalIcons icons = GlobalIcons();
  static GlobalValidators validators = GlobalValidators();

  factory Global() {
    return _singleton;
  }

  Global._internal(bool production);
}
