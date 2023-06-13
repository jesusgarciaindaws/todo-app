import 'package:flutter/material.dart';

class GlobalGradients {
  final transparent = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [
      Color(0xf5ffffff),
      Color(0xf5dfdfdf),
    ],
    stops: [0.0, 1.0],
  );

  final light = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [
      Color(0xffffffff),
      Color(0xffc9cfd3),
    ],
    stops: [0.0, 1.0],
  );

  final white = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [
      Color(0xffffffff),
      Color(0xffffffff),
      Color(0xfff5f5f5),
      Color(0xffc9cfd3),
    ],
    stops: [0.0, 0.2, 0.6, 1.0],
  );

  final gray = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [
      Color(0xfff0f0f0),
      Color(0xffc3c3c3),
    ],
    stops: [0.0, 1.0],
  );

  final darker = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [
      Color(0x012e7db2),
      Color(0x00ffffff),
    ],
    stops: [0.0, 1.0],
  );
}
