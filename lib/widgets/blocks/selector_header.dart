import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/middleware/global.dart';

class SelectorHeaderBlock extends StatelessWidget {
  final Anxeb.Scope scope;
  final String name;
  final String reference;
  final String logoUrl;
  final GestureTapCallback onTap;
  final int tick;
  final bool flat;
  final Icon failedIcon;
  final EdgeInsets margin;

  SelectorHeaderBlock(
      {this.scope,
      this.name,
      this.reference,
      this.logoUrl,
      this.onTap,
      this.tick,
      this.flat,
      this.failedIcon,
      this.margin,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (name == null || reference == null) {
      return Container();
    }

    final captionWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 3),
                margin: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: scope.application.settings.colors.separator,
                    ),
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: scope.application.settings.colors.primary,
                    height: 0.9,
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            reference.toUpperCase(),
            style: TextStyle(
              color: scope.application.settings.colors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );

    return Container(
      margin: margin,
      child: Anxeb.ImageButton(
        height: 60,
        width: 40,
        loadingColor:
            scope.application.settings.colors.primary.withOpacity(0.5),
        loadingPadding: const EdgeInsets.all(15),
        imageUrl: scope.application.api
            .getUri('$logoUrl?webp=80&t=${tick?.toString()}'),
        failedIconColor:
            scope.application.settings.colors.primary.withOpacity(0.2),
        headers: {'Authorization': 'Bearer ${scope.application.api.token}'},
        outerRadius: 10,
        innerRadius: 5,
        innerPadding: flat == true
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        imagePadding: flat == true
            ? EdgeInsets.zero
            : const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        outerFill: flat == true ? null : Colors.white,
        shadow: flat == true ? null : Global.shadows.flat,
        fit: BoxFit.contain,
        shape: BoxShape.rectangle,
        onTap: onTap,
        horizontal: true,
        expanded: true,
        margin: const EdgeInsets.symmetric(vertical: 5),
        failedBody: Row(
          children: <Widget>[
            Container(
              width: 65,
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: failedIcon ??
                  const Icon(Anxeb.FontAwesome5.building, size: 40),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.0,
                      color: scope.application.settings.colors.separator,
                    ),
                  ),
                ),
                child: captionWidget,
              ),
            ),
          ],
        ),
        body: Container(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1.0,
                color: scope.application.settings.colors.separator,
              ),
            ),
          ),
          child: captionWidget,
        ),
      ),
    );
  }
}
