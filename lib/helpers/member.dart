import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/models/primary/member.dart';

class MemberHelper extends Anxeb.ModelHelper<MemberModel> {
  Future showQR() async {
    await scope.dialogs
        .qr(model.id, icon: Icons.person, title: model.fullName, buttons: [
      Anxeb.DialogButton('Cerrar', false),
    ]).show();
  }
}
