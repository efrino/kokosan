import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  final String pemilikID;

  MessagingScreen(this.pemilikID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging'),
      ),
      body: Center(
        child: Text('Halaman Messaging'),
      ),
    );
  }
}
