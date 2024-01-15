// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/chatscreen.dart';
import 'package:mobile_kokosan/cityscreen.dart';
import 'package:mobile_kokosan/favoritescreen.dart';
import 'package:mobile_kokosan/homescreen.dart';
import 'package:mobile_kokosan/kosscreen.dart';
import 'package:mobile_kokosan/login-pencari-kos.dart';
import 'package:mobile_kokosan/messaging_provider.dart';
import 'package:mobile_kokosan/pembayaran.dart';
import 'package:mobile_kokosan/profilscreen.dart';
import 'package:mobile_kokosan/theme.dart';
// import 'package:mobile_kokosan/bottom_navigation.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final String userEmail;

  Homepage(this.userEmail);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0 && _currentIndex > 0) {
              setState(() {
                _currentIndex--;
              });
              _pageController.animateToPage(
                _currentIndex,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else if (details.primaryVelocity! < 0 && _currentIndex < 4) {
              setState(() {
                _currentIndex++;
              });
              _pageController.animateToPage(
                _currentIndex,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
          },
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              HomeScreen(),
              FavoriteScreen(),
              KosScreen(),
              ChatScreen(
                recipientUid: '',
              ),
              ProfilScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Color.fromARGB(255, 68, 0, 203),
        unselectedItemColor: const Color.fromARGB(255, 158, 158, 158),
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Kos Saya',
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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}



// class KosCityScreen extends StatelessWidget {
//   final String cityName;

//   KosCityScreen(this.cityName);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Kos in $cityName'),
//       ),
//       body: Center(
//         child: Text('Kos in $cityName'),
//       ),
//     );
//   }
// }
