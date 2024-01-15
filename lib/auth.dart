import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> signup(String email, String password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCRGY7_XdIQCE9IAjDB0Fd3aoc9UV0TFdY");

    try {
      var response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );

      print(json.decode(response.body));
    } catch (error) {
      // Handle errors, e.g., show an error message to the user
      print("Error during signup: $error");
    }
  }
}
