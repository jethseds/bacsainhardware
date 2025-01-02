import 'package:flutter/material.dart';

class BgPage extends StatefulWidget {
  const BgPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BgPage createState() => _BgPage();
}

class _BgPage extends State<BgPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned container
        Positioned(
          right: -40,
          top: -40,
          child: ClipOval(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        ),
        Positioned(
          left: -40,
          bottom: -40,
          child: ClipOval(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / -3,
          top: MediaQuery.of(context).size.height / 4,
          child: ClipOval(
            child: Container(
              width: MediaQuery.of(context).size.width / 0.94,
              height: MediaQuery.of(context).size.width / 0.94,
              decoration: const BoxDecoration(
                color: Color.fromARGB(74, 0, 0, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
