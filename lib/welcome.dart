import 'package:bacsainhardware/bg.dart';
import 'package:bacsainhardware/checkincheckoutlist.dart';
import 'package:bacsainhardware/home.dart';
import 'package:bacsainhardware/identify.dart';
import 'package:bacsainhardware/invoice.dart';
import 'package:bacsainhardware/login.dart';
import 'package:bacsainhardware/scanner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatefulWidget {
  String users_id;
  WelcomePage({super.key, required this.users_id});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xdd262626),
          title: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: AssetImage('assets/logo.png'),
                  width: 50,
                ),
                Text(
                  'Welcome',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                GestureDetector(
                  child: FaIcon(
                    FontAwesomeIcons.home,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(users_id: widget.users_id),
                      ),
                    );
                  },
                )
              ],
            ),
          )),
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
      body: Stack(
        children: [
          Container(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: const Text(
                          'Tool System',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widgetButton('1', 'CHECK IN'),
                          widgetButton('2', 'CHECK OUT'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widgetButton('3', 'IDENTIFY'),
                          widgetButton('4', 'FIND TOOLS'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widgetButton('5', 'Log Out'),
                          widgetButton('6', 'Invoice'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Manual Setup: Select Your System Type',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            'Not sure? Check your Order Acknowledgement!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          )),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  color: const Color(0xdd262626),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widgetTitle('Products'),
                      widgetSmall('Tool System'),
                      const SizedBox(
                        height: 20,
                      ),
                      widgetTitle('Hardware'),
                      widgetSmall('Other Products'),
                      widgetSmall('Hollowblocks, Gravel, and Sand'),
                      const SizedBox(
                        height: 20,
                      ),
                      widgetTitle('Contact Us'),
                      widgetSmall('+63-9154-758707'),
                      widgetSmall('+63-5129-34188'),
                      const SizedBox(
                        height: 20,
                      ),
                      widgetTitle('Follow Us'),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Color.fromARGB(255, 255, 183, 0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widgetSmall('J. Bacsain Hardware'),
                              widgetSmall('& Construction Supplies'),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clock,
                            color: Color.fromARGB(255, 255, 183, 0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widgetSmall('Monday-Friday'),
                              widgetSmall('8am-5:30'),
                              widgetSmall('Holiday Hours May differ'),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  widgetButton(String id, String label) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            if (id == '1' || id == '2' || id == '4') {
              if (id == '1') {
                label = 'checkin';
              } else if (id == '2') {
                label = 'checkout';
              } else {
                label = 'findtools';
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScannerPage(
                            label: label,
                            users_id: widget.users_id,
                          )));
            }
            if (id == '3') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IdentifyPage(users_id: widget.users_id)));
            }
            if (id == '5') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
            if (id == '6') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InvoicePage()));
            }
          },
          child: Text(
            label,
            style: TextStyle(
                color: Color.fromARGB(255, 255, 183, 0),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ));
  }

  widgetTitle(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Color.fromARGB(255, 255, 183, 0),
          fontWeight: FontWeight.w600,
          fontSize: 20),
    );
  }

  widgetSmall(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
    );
  }
}
