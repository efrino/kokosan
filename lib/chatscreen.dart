import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUid;

  ChatScreen({required this.recipientUid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  String recipientName = '';

  @override
  void initState() {
    super.initState();
    fetchRecipientName();
  }

  Future<void> fetchRecipientName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.recipientUid)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          recipientName = userData['nama'] ?? 'Unknown';
        });
      }
    } catch (e) {
      print('Error fetching recipientName: $e');
    }
  }

  void sendMessage() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String messageText = _messageController.text.trim();

      if (messageText.isNotEmpty) {
        String chatRoomId = getChatRoomId();

        Map<String, dynamic> messageData = {
          'text': messageText,
          'senderUid': currentUser.uid,
          'senderName': currentUser.displayName ?? 'User',
          'timestamp': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatRoomId)
            .collection('messages')
            .add(messageData);

        // Update Firestore to set 'lastMessage'
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('chats')
            .doc(chatRoomId)
            .set({
          'recipientUid': widget.recipientUid,
          'recipientName': recipientName,
          'lastMessage': messageText,
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        _messageController.clear();
      }
    }
  }

  String getChatRoomId() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Sort UIDs to generate a unique chat room ID
      List<String> uids = [currentUser.uid, widget.recipientUid];
      uids.sort();
      return uids.join('_');
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipientName),
        automaticallyImplyLeading: false, // Hapus ikon "kembali"
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatRoomId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(message['senderName']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
