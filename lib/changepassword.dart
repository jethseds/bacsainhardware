import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/bg.dart';
import 'package:bacsainhardware/login.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  bool success = true;
  String message = "";

  Future<void> _changepassword() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    try {
      if (passwordController.text != confirmpasswordController.text ||
          passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match.')),
        );
      } else {
        var uri = Uri.parse("${linkurl}/mobilecontroller/changepassword.php");

        var request = http.MultipartRequest("POST", uri);

        request.fields['btnChangePassword'] = "btnChangePassword";
        request.fields['code'] = codeController.text;
        request.fields['password'] = passwordController.text;

        var streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        print(codeController.text);
        print('Response body: ${response.body}');
        print('Response content type: ${response.headers['content-type']}');

        if (response.statusCode == 200) {
          if (response.headers['content-type']?.contains('application/json') ??
              false) {
            try {
              final data = json.decode(response.body);
              setState(() {
                success = data['success'] == true;
                message = data['message'];
              });

              if (success) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid Code')),
                );
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
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        success = false;
        message = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 183, 0),
      body: Stack(
        children: [
          const BgPage(),
          ListView(
            children: [
              const SizedBox(
                height: 200,
              ),
              Container(
                // Removed Positioned.fill
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 183, 0),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    widgettextField(
                      'Enter Code',
                      FontAwesomeIcons.codeCompare,
                      context,
                      codeController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    widgettextField(
                      'Enter New Password',
                      FontAwesomeIcons.lock,
                      context,
                      passwordController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    widgettextField(
                      'Confirm Password',
                      FontAwesomeIcons.lock,
                      context,
                      confirmpasswordController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 183, 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: _changepassword,
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 183, 0),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget widgettextField(String labelText, IconData iconData,
      BuildContext context, TextEditingController controller) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: const Color(0xdd6A6A6A),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.45,
              child: TextField(
                controller: controller,
                obscureText: labelText != 'Enter Code' ? true : false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      color: Colors.white, // Change this to your desired color
                    ),
                    labelText: labelText),
              ),
            ),
            FaIcon(
              iconData,
              color: Colors.white,
            )
          ],
        ));
  }

  messageShow(String label) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      backgroundColor: Colors.green,
    ));
  }
}
