import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  String users_id;
  TopPage({super.key, required this.users_id});

  @override
  _TopPage createState() => _TopPage();
}

class _TopPage extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/J.Bacsain.png'),
                fit: BoxFit.cover,
              )),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'HARDWARE',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              '& CONSTRUCTION SUPPLIES',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomePage(users_id: widget.users_id)));
      },
    );
  }
}
