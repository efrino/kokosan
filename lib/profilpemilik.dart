import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/change_password.dart';
import 'package:mobile_kokosan/profile_settings.dart';
import 'package:mobile_kokosan/splash_screen.dart';

class ProfilPemilik extends StatelessWidget {
  final String pemilikID;

  ProfilPemilik(this.pemilikID);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pemilik'),
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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
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
                    buildProfileInfo(
                      'Tanggal Lahir',
                      formatTimestamp(userData['tanggal_lahir']),
                    ),
                    buildProfileInfo('Nomor Telepon',
                        userData['nomor_telepon'] ?? 'Nomor Telepon Default'),
                    buildProfileInfo('Jenis Kelamin',
                        userData['jenis_kelamin'] ?? 'Belum diatur'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 8),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ),
      ],
    );
  }

  Widget buildProfileButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.blue, // Change button color to match the theme
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false,
    );
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return '${date.day}-${date.month}-${date.year}';
    } else if (timestamp is DateTime) {
      return '${timestamp.day}-${timestamp.month}-${timestamp.year}';
    } else {
      return 'Invalid Timestamp Format';
    }
  }
}
