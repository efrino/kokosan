import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/detailkos.dart';

class Kosan extends StatelessWidget {
  final String pemilikID;

  Kosan(this.pemilikID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kosan Saya'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kokosan')
            .doc('kota')
            .collection('semarang')
            .where('pemilikID', isEqualTo: pemilikID)
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
                child: Text('Tidak ada data kos untuk pemilik ini.'),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot document = docs[index];
                final String nama = document['nama'] ?? 'No Title';
                final String alamat = document['alamat'] ?? 'No Location';
                final int harga = document['harga'] ?? 0;

                return ListTile(
                  title: Text(nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alamat),
                      Text('Harga: Rp.$harga,00'),
                    ],
                  ),
                  onTap: () {
                    // Navigasi ke halaman detail dengan membawa data kos
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailKosScreen(kosData: {
                          'nama': nama,
                          'alamat': alamat,
                          'harga': harga,
                          // Tambahkan properti lain sesuai kebutuhan
                        }),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
