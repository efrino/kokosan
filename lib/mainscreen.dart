import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/chatscreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(chat['recipientName']),
                subtitle: Text(chat['lastMessage']),
                onTap: () async {
                  // Navigate to ChatScreen and wait for result
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        recipientUid: chat['recipientUid'],
                      ),
                    ),
                  );

                  // Handle the result if needed
                  if (result != null && result is String) {
                    // Do something with the result (if needed)
                    print('Received result from ChatScreen: $result');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
