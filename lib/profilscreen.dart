import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/change_password.dart';
import 'package:mobile_kokosan/profile_settings.dart';
import 'package:mobile_kokosan/splash_screen.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil Pengguna'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var userData = snapshot.data?.data() as Map<String, dynamic>?;

            if (userData != null) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Replace with the URL of the profile picture
                    ),
                    SizedBox(height: 16),
                    Text(
                      userData['nama'] ?? 'Nama Default',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      userData['email'] ?? 'Email Default',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    buildProfileInfo(
                      'Tanggal Lahir',
                      formatTimestamp(),
                    ),
                    Divider(),
                    buildProfileInfo(
                      'Nomor Telepon',
                      userData['nomor_telepon'] ?? 'Nomor Telepon Default',
                    ),
                    Divider(),
                    buildProfileInfo(
                      'Jenis Kelamin',
                      userData['jenis_kelamin'] ?? 'Belum diatur',
                    ),
                    SizedBox(height: 24),
                    buildProfileButton(
                      'Profile Settings',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileSettingsScreen(userUid: user?.uid),
                          ),
                        );
                      },
                    ),
                    buildProfileButton(
                      'Change Password',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    buildProfileButton(
                      'Logout',
                      () {
                        _logout(context);
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('User data not available'),
              );
            }
          }
        },
      ),
    );
  }

  Widget buildProfileInfo(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false,
    );
  }

  String formatTimestamp() {
    DateTime currentDate = DateTime.now();
    return '${currentDate.day}-${currentDate.month}-${currentDate.year}';
  }
}
