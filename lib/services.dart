import 'dart:convert';

import 'package:bacsainhardware/api.dart';
import 'package:bacsainhardware/changepassword.dart';
import 'package:http/http.dart' as http;

class Services {
  // signUp(
  //     String firstname, String lastname, String email, String password) async {
  //   UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  //   String? uid = userCredential.user!.uid;

  //   FirebaseFirestore.instance.collection('users').doc(uid).set({
  //     'firstname': firstname,
  //     'lastname': lastname,
  //     'email.': email,
  //   });
  // }

  // changePassword(String email) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //   } on FirebaseAuthException catch (error) {
  //     print("Error: Email not registered.");
  //   } catch (error) {
  //     print("An unexpected error occurred: $error");
  //   }
  // }

  // checkIn(String barcode, String duedate, String notes, String description) {
  //   FirebaseFirestore.instance.collection('product').doc().set({
  //     'barcode': barcode,
  //     'duedate': duedate,
  //     'notes': notes,
  //     'description': description,
  //     'status': 'checkin'
  //   });
  // }
}
