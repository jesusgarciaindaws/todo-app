import 'package:flutter/material.dart';

class GlobalShadows {
  final normal = [
    const BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 4,
        spreadRadius: 0,
        color: Color(0x88333333))
  ];
  final flat = [
    const BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color(0x1f555555))
  ];
  final button = [
    const BoxShadow(
        offset: Offset(0, 3),
        blurRadius: 4,
        spreadRadius: 0,
        color: Color(0x25000000))
  ];
  final text = [
    const BoxShadow(
        offset: Offset(1, 1),
        blurRadius: 1,
        spreadRadius: 0,
        color: Color(0x90000000))
  ];
  final panel = [
    const BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 10,
        spreadRadius: 0,
        color: Color(0x25000000))
  ];
}
