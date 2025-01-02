import 'package:bacsainhardware/checkincheckout.dart';
import 'package:bacsainhardware/identify.dart';
import 'package:bacsainhardware/intro.dart';
import 'package:bacsainhardware/login.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IntroPage(),
    );
  }
}
