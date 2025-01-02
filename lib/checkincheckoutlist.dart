import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/home.dart';
import 'package:bacsainhardware/top.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class CheckinCheckoutListPage extends StatefulWidget {
  String users_id;
  final label;
  CheckinCheckoutListPage(
      {super.key, required this.label, required this.users_id});

  @override
  _CheckinCheckoutListPage createState() => _CheckinCheckoutListPage();
}

class _CheckinCheckoutListPage extends State<CheckinCheckoutListPage> {
  List data = [];
  Future<void> fetchData() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    final response = await http.get(
        Uri.parse(
            '${linkurl}/mobilecontroller/checkincheckoutlist.php?label=${widget.label}'),
        headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
    });
  }

  List totalrowsdata = [];
  String totalrows = "";
  Future<void> totalRowsData() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    final response = await http.get(
        Uri.parse(
            '${linkurl}/mobilecontroller/checkincheckoutlisttotalrows.php?label=${widget.label}'),
        headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      totalrowsdata = jsonData;
      for (var item in totalrowsdata) {
        totalrows = item['totalrows'];
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
    totalRowsData();
    showImage(img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
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
                  'Check In',
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
                            WelcomePage(users_id: widget.users_id),
                      ),
                    );
                  },
                )
              ],
            ),
          )),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          TopPage(users_id: widget.users_id),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              'Checkin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                  '${totalrows} of ${totalrows} Raws Visible', // Display the total count
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            )
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: data.map((product) {
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {},
                            child: FutureBuilder<String>(
                              future: showImage(product['images'] ?? ''),
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
                                      width: 100,
                                    ),
                                  );
                                } else {
                                  return Text("No image available");
                                }
                              },
                            ),
                          )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Barcode: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${product['barcode']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Name: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${product['title']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    '${product['description']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
