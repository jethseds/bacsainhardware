import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/checkincheckoutlist.dart';
import 'package:bacsainhardware/login.dart';
import 'package:bacsainhardware/scanner.dart';
import 'package:bacsainhardware/top.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class CheckinCheckoutPage extends StatefulWidget {
  final String barcode; // Expect a String value for barcode
  final label;
  String users_id;
  CheckinCheckoutPage(
      {super.key,
      required this.barcode,
      required this.label,
      required this.users_id});

  @override
  // ignore: library_private_types_in_public_api
  _CheckinCheckoutPage createState() => _CheckinCheckoutPage();
}

class _CheckinCheckoutPage extends State<CheckinCheckoutPage> {
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController notesController = TextEditingController();
  late TextEditingController barcodeController;

  List<dynamic> data = []; // All products
  String products_id = "";
  Future<void> fetchData() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    final response = await http.get(
      Uri.parse(
          '${linkurl}/mobilecontroller/products.php?barcode=1234567890123'),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var jsonBody = response.body;
      print("Response Body: $jsonBody"); // Debug log to check response

      if (jsonBody.isNotEmpty) {
        try {
          var jsonData = json.decode(jsonBody);
          setState(() {
            data = jsonData;
            print(data);

            for (var item in data) {
              products_id = item['products_id'];
              print(products_id);
            }
          });
        } catch (e) {
          print("JSON Parsing Error: $e");
        }
      } else {
        print("Empty response from API");
      }
    } else {
      print('Failed to fetch products. Status Code: ${response.statusCode}');
    }
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
    // Initialize the TextEditingController with the passed barcode value
    barcodeController = TextEditingController(text: widget.barcode);
    fetchData();
    showImage(img);
  }

  @override
  void dispose() {
    barcodeController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void updateBarcodeValue(String newValue) {
    // Update the barcode value in the TextField programmatically
    setState(() {
      barcodeController.text = newValue;
    });
  }

  TextEditingController duedateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        duedateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  bool success = true;
  String message = "";

  Future<void> checkincheckout() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();

    try {
      var uri = Uri.parse("${linkurl}/mobilecontroller/checkincheckout.php");

      var request = http.MultipartRequest("POST", uri);

      request.fields['checkIn'] = "checkIn";
      request.fields['products_id'] = products_id.toString();
      request.fields['label'] = widget.label;

      var streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response body: ${response.body}');
      print('Response content type: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          try {
            final data = json.decode(response.body);
            setState(() {});

            if (success) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('${widget.label} Successful'),
                    content: Text('Successfully ${widget.label}.'),
                  );
                },
              );

              // Delay for 2 seconds before navigating
              Future.delayed(Duration(seconds: 3), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckinCheckoutListPage(
                          label: widget.label, users_id: widget.users_id)),
                );
              });
            }
          } catch (e) {
            print('Error parsing JSON: $e');
            setState(() {
              success = false;
              message = 'Failed to parse response';
            });
          }
        } else {
          print('Unexpected response format');
          setState(() {
            success = false;
            message = 'Unexpected response format';
          });
        }
      } else {
        print("Failed with status code: ${response.statusCode}");
        setState(() {
          success = false;
          message = 'Request failed with status code ${response.statusCode}';
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
      body: Stack(
        children: [
          Container(
            child: ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      TopPage(users_id: widget.users_id),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Code:',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 30,
                                  color: Colors.black38,
                                  child: Text(widget.barcode),
                                )
                              ],
                            ),
                            GestureDetector(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.barcode),
                                  Text(
                                    'Scan',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScannerPage(
                                        label: widget.label,
                                        users_id: widget.users_id),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Colors
                                            .black), // Set the color and width you want
                                  ),
                                ),
                                child: TextField(
                                  controller: barcodeController,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.map((product) {
                            return Text(
                              'Name: ${product['title'] ?? 'No Name'}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Tool Code:',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Colors
                                            .black), // Set the color and width you want
                                  ),
                                ),
                                child: Text('${widget.barcode}')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.map((product) {
                            return Text(
                              'Description: ${product['description'] ?? 'No description available'}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          widgetButton('Reset'),
                          widgetButton('Submit'),
                        ],
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

  widgetButton(String label) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            if (label == 'Reset') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WelcomePage(users_id: widget.users_id)));
            } else {
              // Services().checkIn(widget.barcode, duedateController.text,
              //     notesController.text, descriptionController.text);
              checkincheckout();
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CheckinListPage()));
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
