// ignore_for_file: unused_import, unused_field, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/adminpage.dart';
import 'package:mobile_kokosan/daftar-as-seeker.dart';
import 'package:mobile_kokosan/home_page.dart';
import 'package:mobile_kokosan/lupa_password.dart';
import 'package:mobile_kokosan/pemilikpage.dart';

class LoginPencariKos extends StatefulWidget {
  const LoginPencariKos({Key? key}) : super(key: key);

  @override
  _LoginPencariKosState createState() => _LoginPencariKosState();
}

class _LoginPencariKosState extends State<LoginPencariKos> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Fetch user role from Firestore
      String userRole =
          await getUserRoleFromFirestore(userCredential.user?.uid ?? '');

      Widget homepage = Homepage(userCredential.user?.email ?? "");

      switch (userRole) {
        case 'pencari_kos':
          homepage = Homepage(userCredential.user?.email ?? "");
          break;
        case 'admin':
          homepage = AdminPage();
          break;
        default:
          print("Invalid user role: $userRole");
          break;
      }

      // Check the user role and navigate accordingly
      if (userRole == 'pencari_kos') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => homepage,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Anda tidak memiliki hak akses.'),
            action: SnackBarAction(
              label: 'Tutup',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email atau Password Anda Salah!'),
          action: SnackBarAction(
            label: 'Tutup',
            onPressed: () {},
          ),
        ),
      );
      print("Error: $e");
    }
  }

  Future<String> getUserRoleFromFirestore(String uid) async {
    try {
      print("Fetching user role for UID: $uid");

      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        String userRole = userSnapshot['role'] ?? '';
        print("User Role: $userRole");
        return userRole;
      } else {
        print("User document does not exist for UID: $uid");
        return '';
      }
    } catch (e) {
      print("Error fetching user role: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Pencari Kos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 245, 245, 245),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/login.png', // Adjust the path accordingly
                  height: 120 * fem,
                ),
                SizedBox(height: 16 * fem),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 224, 248, 140),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10 * fem),
                      ),
                      hintText: 'Masukkan Email Anda',
                    ),
                  ),
                ),
                SizedBox(height: 16 * fem),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.key),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 248, 140),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10 * fem),
                    ),
                    hintText: 'Masukkan Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24 * fem),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Form is valid, perform login
                      _login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff5843BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20 * fem),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 16 * fem),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(
                        fontSize: 14 * ffem,
                        color: Color.fromARGB(255, 50, 50, 50),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigasi ke halaman DaftarAsSeeker
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarAsSeeker(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar sekarang!',
                        style: TextStyle(
                          fontSize: 13 * ffem,
                          color: Color(0xff5843BE),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16 * fem),
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman LupaPassword
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LupaPassword(),
                      ),
                    );
                  },
                  child: Text(
                    'Lupa Password?',
                    style: TextStyle(
                      fontSize: 12 * ffem,
                      color: Color(0xff5843BE),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
