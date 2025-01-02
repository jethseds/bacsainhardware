import 'dart:convert';
import 'package:bacsainhardware/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestingPage extends StatefulWidget {
  TestingPage({super.key});

  @override
  _TestingPage createState() => _TestingPage();
}

class _TestingPage extends State<TestingPage> {
  List data = [];
  Future<void> fetchData() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    final response = await http.get(
        Uri.parse('${linkurl}/mobilecontroller/products.php'),
        headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice PDF Generator"),
      ),
      body: Center(),
    );
  }
}
