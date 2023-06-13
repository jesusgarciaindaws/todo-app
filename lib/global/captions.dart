import 'package:todo_app/models/common/identity.dart';

class GlobalCaptions {
  String identityCaption(IdentityType value) {
    switch (value) {
      case IdentityType.license:
        return 'Licencia';
      case IdentityType.passport:
        return 'Pasaporte';
      case IdentityType.personal:
        return 'Identificación';
      case IdentityType.company:
        return 'NIF';
    }
    return null;
  }

  String languageLabels(String code) {
    final languageLabels = {
      'es': 'Español',
      'en': 'English',
    };

    return languageLabels[code];
  }
}
