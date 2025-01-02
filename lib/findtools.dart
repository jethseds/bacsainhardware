import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/home.dart';
import 'package:bacsainhardware/scanner.dart';
import 'package:bacsainhardware/top.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class FintToolsPage extends StatefulWidget {
  final String barcode;
  final label;
  String users_id;
  FintToolsPage(
      {super.key,
      required this.barcode,
      required this.label,
      required this.users_id});

  @override
  _FintToolsPage createState() => _FintToolsPage();
}

class _FintToolsPage extends State<FintToolsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
      body: ListView(),
    );
  }
}
