import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KosScreen extends StatefulWidget {
  @override
  _KosScreenState createState() => _KosScreenState();
}

class _KosScreenState extends State<KosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Kos Anda'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kokosan')
            .doc('kota')
            .collection('semarang')
            .where('isPaid',
                isEqualTo: true) // Filter only paid (occupied) Kosts
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Center(
                child: Text('Anda belum memiliki kos'),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot document = docs[index];
                final Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                if (data.containsKey('pemilikID')) {
                  final String nama = data['nama'] ?? 'No Title';
                  final String alamat = data['alamat'] ?? 'No Location';
                  final int harga = data['harga'] ?? 0;
                  final String uid =
                      FirebaseAuth.instance.currentUser?.uid ?? '';

                  return ListTile(
                    title: Text(nama),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alamat),
                        Text('Harga: Rp.$harga,00'),
                        if (uid == data['uid'])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kos Saya'),
                              ElevatedButton(
                                onPressed: () {
                                  // Implement monthly billing logic here
                                  // You can show a dialog for payment confirmation
                                  // and update the 'isPaid' field accordingly
                                },
                                child: Text('Bayar Tagihan Bulanan'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // Show a confirmation dialog for exiting Kost
                                  bool exitConfirmed = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Exit from Kost'),
                                        content: Text(
                                            'Are you sure you want to exit from this Kost?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Text('Exit'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // If the user confirms exit, update Firestore
                                  if (exitConfirmed == true) {
                                    await FirebaseFirestore.instance
                                        .collection('kokosan')
                                        .doc('kota')
                                        .collection('semarang')
                                        .doc(document.id)
                                        .update({
                                      'isPaid': false,
                                      'uid': '',
                                    });
                                  }
                                },
                                child: Text('Exit from Kost'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                } else {
                  print("Document at index $index doesn't contain 'pemilikID'");
                  return SizedBox.shrink();
                }
              },
            );
          }
        },
      ),
    );
  }
}
