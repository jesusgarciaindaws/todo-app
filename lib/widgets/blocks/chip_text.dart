import 'package:flutter/material.dart';

class ChipText extends StatelessWidget {
  final String text;
  final Color chipColor;
  final TextStyle textStyle;
  final EdgeInsets padding;

  const ChipText({
    Key key,
    this.text,
    this.chipColor,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Text(
        text,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        style: textStyle ??
            const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
      ),
    );
  }
}
