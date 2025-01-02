import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/sidebar.dart';
import 'package:bacsainhardware/top2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  String users_id;
  HomePage({super.key, required this.users_id});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
      drawer: SiderBarPage(users_id: widget.users_id),
      body: ListView(),
    );
  }
}
