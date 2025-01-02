import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/bg.dart';
import 'package:bacsainhardware/changepassword.dart';
import 'package:bacsainhardware/forgotpassword.dart';
import 'package:bacsainhardware/register.dart';
import 'package:bacsainhardware/welcome.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    String url = '${linkurl}/mobilecontroller/login.php';
    final String email = emailController.text;
    final String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          String users_id = data['users_id'];

          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => WelcomePage(users_id: users_id)));
          });
        } else {
          // Show error message using Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign-in failed. Please check your credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle response error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
                      'LOGIN',
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
                      'Enter your Email',
                      FontAwesomeIcons.at,
                      context,
                      emailController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    widgettextField(
                      'Enter your password',
                      FontAwesomeIcons.eye,
                      context,
                      passwordController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage(),
                              ),
                            );
                          },
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 183, 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          _login();
                        },
                        child: const Text(
                          'LOGIN',
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
                              text: 'Sign Up',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
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
                obscureText: labelText == "Enter your password" ? true : false,
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
      backgroundColor: Colors.red,
    ));
  }
}
