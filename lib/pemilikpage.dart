import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/addkos.dart';
import 'package:mobile_kokosan/messagingscreen.dart';
import 'package:mobile_kokosan/profilpemilik.dart';

class HomePemilik extends StatelessWidget {
  final String email;
  final String pemilikID;

  HomePemilik(this.email, this.pemilikID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home Pemilik'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kokosan')
            .doc('kota')
            .collection('semarang')
            .where('pemilikID', isEqualTo: pemilikID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var kosList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: kosList.length,
            itemBuilder: (context, index) {
              var kosData = kosList[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(kosData['nama']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alamat: ${kosData['alamat']}'),
                      Text('Harga: ${kosData['harga']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the AddKosPage for editing
                          _navigateToEditKos(context, kosList[index].id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Show a confirmation dialog before deletion
                          _showDeleteConfirmationDialog(
                              context, kosList[index].id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah Kos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigasi ke halaman Home
              break;
            case 1:
              _navigateToAddKos(context); // Ganti dengan fungsi yang sesuai
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagingScreen(pemilikID),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilPemilik(pemilikID),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  // Fungsi untuk navigasi ke halaman edit data kos
  void _navigateToEditKos(BuildContext context, String kosID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddKosPage(pemilikID, kosID),
      ),
    );
  }

  // Fungsi untuk navigasi ke halaman penambahan data kos
  void _navigateToAddKos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddKosPage(pemilikID),
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, String kosID) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Kos"),
        content: Text("Are you sure you want to delete this Kos?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Perform the deletion
              _deleteKos(context, kosID);
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

// Function to delete a Kos
void _deleteKos(BuildContext context, String kosID) async {
  try {
    await FirebaseFirestore.instance
        .collection('kokosan')
        .doc('kota')
        .collection('semarang')
        .doc(kosID)
        .delete();

    Navigator.of(context).pop(); // Close the confirmation dialog
  } catch (e) {
    print("Error deleting Kos: $e");
    // Handle error, show a message, or perform any necessary actions
  }
}
