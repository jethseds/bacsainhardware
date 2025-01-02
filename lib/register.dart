import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/bg.dart';
import 'package:bacsainhardware/login.dart';
import 'package:bacsainhardware/services.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  bool isChecked = false;

  bool success = true;
  String message = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmpasswordController
        .dispose(); // Don't forget to dispose this controller
    super.dispose();
  }

  Future<void> register() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();

    try {
      if (passwordController.text != confirmpasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match.')),
        );
      } else {
        var uri = Uri.parse("${linkurl}/mobilecontroller/register.php");

        var request = http.MultipartRequest("POST", uri);

        request.fields['btnRegister'] = "btnRegister";
        request.fields['firstname'] = firstnameController.text;
        request.fields['lastname'] = lastnameController.text;
        request.fields['email'] = emailController.text;
        request.fields['password'] = passwordController.text;

        var streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Registration Successful'),
                      content: Text('Successfully Registered.'),
                    );
                  },
                );

                // Delay for 2 seconds before navigating
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
          SingleChildScrollView(
            // Change ListView to SingleChildScrollView
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(
                  top: 150, left: 20, right: 20), // Adjust margins for top
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 183, 0),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widgettextField(
                          1, 'First Name', context, firstnameController),
                      widgettextField(
                          2, 'Last Name', context, lastnameController),
                    ],
                  ),
                  const SizedBox(height: 40),
                  widgettextField(
                      3, 'Enter your Email', context, emailController),
                  const SizedBox(height: 30),
                  widgettextField(
                      4, 'Your Password', context, passwordController),
                  const SizedBox(height: 20),
                  widgettextField(4, 'Confirm Password', context,
                      confirmpasswordController),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        RichText(
                          text: const TextSpan(
                            text: "I Agree with the ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'privacy ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'policy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 183, 0),
                        borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        if (!isChecked) {
                          messageShow('Please Agree with terms and condition',
                              Colors.red);
                        } else if (passwordController.text !=
                                confirmpasswordController.text ||
                            passwordController.text.isEmpty) {
                          messageShow('Password Not Match', Colors.red);
                        } else {
                          register();
                        }
                      },
                      child: const Text(
                        'SIGNUP',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(top: 20),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 183, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
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
          ),
        ],
      ),
    );
  }

  Widget widgettextField(int id, String labelText, BuildContext context,
      TextEditingController controller) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: const Color(0xdd6A6A6A),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            SizedBox(
              width: (id == 1 || id == 2)
                  ? MediaQuery.of(context).size.width / 4
                  : MediaQuery.of(context).size.width / 1.45,
              child: TextField(
                controller: controller,
                obscureText: id == 4 ? true : false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    labelText: labelText),
              ),
            ),
            FaIcon(
              id == 4 ? FontAwesomeIcons.lock : null,
              color: Colors.white,
            )
          ],
        ));
  }

  messageShow(String label, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      backgroundColor: color,
    ));
  }
}
