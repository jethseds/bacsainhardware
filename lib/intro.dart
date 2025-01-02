import 'dart:async';

import 'package:bacsainhardware/bg.dart';
import 'package:bacsainhardware/login.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroPage createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    // Start a timer that will navigate to the welcome page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Replace with your welcome page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 227, 160),
      body: Stack(
        children: [
          const BgPage(),
          // Move Positioned.fill inside the Stack
          Positioned.fill(
            top: -250,
            child: Image.asset(
              'assets/1728454694077.gif',
            ),
          ),
          ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 0.65,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Life Happens, Workers Helps!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
