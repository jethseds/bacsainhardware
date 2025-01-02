import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Top2Page extends StatefulWidget {
  Top2Page({super.key});

  @override
  _Top2Page createState() => _Top2Page();
}

class _Top2Page extends State<Top2Page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: FaIcon(
                FontAwesomeIcons.bars,
                color: Color.fromARGB(255, 255, 183, 0),
              ),
            ),
          ),
          Image(
            image: AssetImage('assets/logo.png'),
            width: 50,
          ),
          Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/J.Bacsain.png'),
                    fit: BoxFit.cover,
                    width: 100,
                  )),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'HARDWARE',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '& CONSTRUCTION SUPPLIES',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
