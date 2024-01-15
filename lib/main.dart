// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/auth.dart';
import 'package:mobile_kokosan/favoritescreen.dart';
import 'package:mobile_kokosan/firebase_options.dart';
import 'package:mobile_kokosan/chatscreen.dart';
// import 'package:mobile_kokosan/home_page.dart';
// import 'package:mobile_kokosan/pembayaran.dart';
import 'package:mobile_kokosan/splash_page.dart';
import 'package:mobile_kokosan/splash_screen.dart';
import 'package:provider/provider.dart';

import 'messaging_provider.dart'; // Import the new provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(
            create: (_) => MessagingProvider()), // Add the new provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/home': (context) => SplashPage(),
          '/pesan': (context) => ChatScreen(
                recipientUid: '',
              ),
        },
      ),
    );
  }
}
