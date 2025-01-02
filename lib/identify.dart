import 'dart:convert';
import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/scanner.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class IdentifyPage extends StatefulWidget {
  String users_id;
  IdentifyPage({super.key, required this.users_id});

  @override
  _IdentifyPage createState() => _IdentifyPage();
}

class _IdentifyPage extends State<IdentifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
      body: ListView(),
    );
  }
}
