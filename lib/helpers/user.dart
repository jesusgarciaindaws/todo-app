import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/models/primary/user.dart';

class UserHelper extends anxeb.ModelHelper<UserModel> {
  Future showQR() async {
    await scope.dialogs
        .qr(model.id, icon: Icons.person, title: model.fullName, buttons: [
      anxeb.DialogButton('Cerrar', false),
    ]).show();
  }
}
