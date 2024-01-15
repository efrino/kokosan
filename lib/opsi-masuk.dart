import 'package:flutter/material.dart';
// ignore: unnecessary_import
// import 'package:flutter/gestures.dart';
import 'package:mobile_kokosan/login-pemilik-kos.dart';
import 'package:mobile_kokosan/login-pencari-kos.dart';
// ignore: unnecessary_import
import 'dart:ui';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_kokosan/utils.dart';

class opsiMasuk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20 * fem, 40 * fem, 20 * fem, 20 * fem),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E3192), Color(0xFFCFD8DC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Masuk ke Kokosan',
              style: SafeGoogleFont(
                'Inter',
                fontSize: 24 * ffem,
                fontWeight: FontWeight.w700,
                color: Color(0xffffffff),
              ),
            ),
            SizedBox(height: 20 * fem),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPencariKos()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xfffffbfb),
                padding: EdgeInsets.symmetric(
                    vertical: 10 * fem, horizontal: 20 * fem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
              ),
              child: Text(
                'Pencari Kos',
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 16 * ffem,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ),
            SizedBox(height: 10 * fem),
            Text(
              'atau',
              style: SafeGoogleFont(
                'Inter',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w400,
                color: Color(0xffffffff),
              ),
            ),
            SizedBox(height: 10 * fem),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPemilikKos()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xfffffbfb),
                padding: EdgeInsets.symmetric(
                    vertical: 10 * fem, horizontal: 20 * fem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
              ),
              child: Text(
                'Pemilik Kos',
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 16 * ffem,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ),
            SizedBox(height: 20 * fem),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Butuh bantuan?',
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffffffff),
                  ),
                ),
                SizedBox(width: 5 * fem),
                Text(
                  'Klik di sini',
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff05ff00),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
