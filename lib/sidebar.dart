import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/home.dart';
import 'package:bacsainhardware/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class SiderBarPage extends StatefulWidget {
  String users_id;
  SiderBarPage({super.key, required this.users_id});

  @override
  // ignore: library_private_types_in_public_api
  _SiderBarPage createState() => _SiderBarPage();
}

class _SiderBarPage extends State<SiderBarPage> {
  List data = [];
  String fullname = "";
  String images = "";
  Future<void> fetchData() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    final response = await http.get(
        Uri.parse(
            '${linkurl}/mobilecontroller/profile.php?users_id=${widget.users_id}'),
        headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
      for (var item in data) {
        fullname = '${item['firstname']} ${item['lastname']}';
        images = '${item['images']}';
      }
    });
  }

  String img = "";
  Future<String> showImage(String img) async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    return "${linkurl}/images/${img}";
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    showImage(img);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 150, // Set your desired height here
                    child: DrawerHeader(
                      child: Row(
                        children: [
                          FutureBuilder<String>(
                            future: showImage(images),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error loading image");
                              } else if (snapshot.hasData) {
                                return ClipOval(
                                  child: Image.network(
                                    snapshot.data!,
                                    width: 50,
                                  ),
                                );
                              } else {
                                return Text("No image available");
                              }
                            },
                          ),
                          SizedBox(
                              width:
                                  10), // Add some spacing between icon and text
                          Text(
                            '${fullname}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(255, 255, 183, 0),
                    child: ListTile(
                      title: const Text(
                        'Home',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(users_id: widget.users_id)),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Color.fromARGB(255, 255, 183, 0),
                    child: ListTile(
                      title: const Text(
                        'Hardware',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(users_id: widget.users_id)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: Color.fromARGB(255, 255, 183, 0),
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.signOut),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(users_id: widget.users_id)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
