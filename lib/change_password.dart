import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _changePassword(context);
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Re-authenticate the user with the current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: _currentPasswordController.text,
      );

      await user?.reauthenticateWithCredential(credential);

      // Change the user's password
      await user?.updatePassword(_newPasswordController.text);

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      print('Error changing password: $e');
      // Handle the error as needed
      // You might want to display an error message to the user
    }
  }
}
