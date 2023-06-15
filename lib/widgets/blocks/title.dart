import 'package:anxeb_flutter/middleware/settings.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:flutter/material.dart';

class TitleBlock extends StatelessWidget {
  final anxeb.Scope scope;
  final String title;
  final IconData icon;
  final String warning;
  final String imageUrl;
  final String subtitle;
  final Color iconColor;
  final double iconScale;
  final bool noMargin;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final VoidCallback onTap;

  const TitleBlock({
    this.scope,
    this.title,
    this.icon,
    this.warning,
    this.imageUrl,
    this.subtitle,
    this.iconColor,
    this.iconScale,
    this.noMargin,
    this.titleStyle,
    this.subtitleStyle,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: noMargin == true ? 0 : 6, top: 12),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: settings.colors.separator,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 6),
            child: icon != null
                ? Icon(
                    icon,
                    color: iconColor,
                    size: 40 * (iconScale ?? 1.0),
                  )
                : anxeb.ImageButton(
                    height: 70,
                    width: 70,
                    imageUrl: imageUrl,
                    innerPadding: const EdgeInsets.all(2),
                    headers: {
                      'Authorization': 'Bearer ${scope.application.api.token}'
                    },
                    margin: const EdgeInsets.only(right: 8),
                    outerBorderColor: scope.application.settings.colors.primary,
                    failedIcon: Icons.account_circle,
                    outerThickness: 2,
                    failedIconColor: scope.application.settings.colors.primary
                        .withOpacity(0.3),
                    onTap: () async {
                      onTap?.call();
                    },
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: subtitleStyle ??
                      Text(
                        subtitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: -0.2,
                          color: settings.colors.navigation,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                ),
                Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: settings.colors.secudary,
                        letterSpacing: -0.4,
                      ),
                  overflow: TextOverflow.clip,
                ),
                if (warning != null)
                  Container(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      warning.toUpperCase(),
                      style: titleStyle ??
                          TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: settings.colors.danger,
                            letterSpacing: 0,
                          ),
                      overflow: TextOverflow.clip,
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Settings get settings => scope.application.settings;
}
