import 'package:flutter/material.dart';
import 'package:mobile_kokosan/chatscreen.dart';

class DetailKosScreen extends StatelessWidget {
  final Map<String, dynamic> kosData;

  DetailKosScreen({required this.kosData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kos'),
      ),
      body: Column(
        children: [
          // Other details of the kos

          ElevatedButton(
            onPressed: () async {
              String pemilikID = kosData['pemilikID'];

              // Navigate to ChatScreen and wait for result
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    recipientUid: pemilikID,
                  ),
                ),
              );

              // Handle the result if needed
              if (result != null && result is String) {
                // Do something with the result (if needed)
                print('Received result from ChatScreen: $result');
              }
            },
            child: Text('Chat dengan Pemilik'),
          ),
        ],
      ),
    );
  }
}
