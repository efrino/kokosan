import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/detailkos.dart';

class KosList extends StatelessWidget {
  final String? searchQuery;

  KosList({required this.searchQuery, double? ratingFilter});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    print('Search Query: $searchQuery');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('kokosan')
          .doc('kota')
          .collection('semarang')
          .where('nama', isGreaterThanOrEqualTo: searchQuery)
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
              child: Text('No data available'),
            );
          }

          // Filter data based on search query
          final filteredDocs = docs.where((document) {
            final Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;

            if (searchQuery != null) {
              return data['nama']
                  .toLowerCase()
                  .contains(searchQuery!.toLowerCase());
            } else {
              return true; // Include all items if no search query
            }
          }).toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = filteredDocs[index];
              final Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              if (data.containsKey('pemilikID')) {
                final String nama = data['nama'] ?? 'No Title';
                final String alamat = data['alamat'] ?? 'No Location';
                final int harga = data['harga'] ?? 0;
                final int bedrooms = data['bedrooms'] ?? 0;
                final int bathrooms = data['bathrooms'] ?? 0;
                final bool isPaid = data['isPaid'] ?? false;
                final String pemilikID = data['pemilikID'] ?? '';
                final String gambarURL =
                    data['gambarURL'] ?? ''; // Add this line

                if (!isPaid) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(gambarURL),
                      ),
                      title: Text(nama),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alamat),
                          Text('Harga: Rp.$harga,00'),
                          ElevatedButton(
                            onPressed: () async {
                              if (user != null && pemilikID != user.uid) {
                                final userSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get();

                                if (userSnapshot.exists) {
                                  final userData = userSnapshot.data()
                                      as Map<String, dynamic>;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailKosScreen(
                                        kosData: {
                                          'nama': nama,
                                          'alamat': alamat,
                                          'harga': harga,
                                          'bathrooms': bathrooms,
                                          'bedrooms': bedrooms,
                                          'pemilikID': pemilikID,
                                          'documentId':
                                              document.id, // Add this line
                                          'userData': userData,
                                          // tambahkan properti lain sesuai kebutuhan
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  print(
                                      "User pencari kos not found for uid: ${user.uid}");
                                  // Tindakan lain yang sesuai jika data pemilikID tidak ditemukan
                                }
                              } else {
                                print(
                                    "Anda tidak bisa memesan produk Anda sendiri");
                              }
                            },
                            child: Text('Lihat Detail'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Kos sudah terjual, tetap tampilkan tetapi dengan tambahan penghuninya dengan memanggil userID bagian nama
                  return SizedBox.shrink();
                }
              } else {
                print("Document at index $index doesn't contain 'pemilikID'");
                return SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}
