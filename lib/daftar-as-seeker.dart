import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DaftarAsSeeker extends StatefulWidget {
  @override
  _DaftarAsSeekerState createState() => _DaftarAsSeekerState();
}

class _DaftarAsSeekerState extends State<DaftarAsSeeker> {
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Pencari Kos',
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
                Icon(
                  Icons.account_circle, // Ganti dengan ikon Icons
                  size: 120 * fem,
                  color: Colors.blue, // Sesuaikan dengan warna yang diinginkan
                ),
                SizedBox(height: 16 * fem),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
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
                          hintText: 'Enter your email',
                        ),
                      ),
                      SizedBox(height: 16 * fem),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
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
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscurePassword = !_isObscurePassword;
                              });
                            },
                            icon: Icon(
                              _isObscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * fem),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _isObscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password cannot be empty';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.key),
                          filled: true,
                          fillColor: Color.fromARGB(255, 224, 248, 140),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 * fem),
                          ),
                          hintText: 'Tulis ulang password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscureConfirmPassword =
                                    !_isObscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _isObscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24 * fem),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        print(
                            'User successfully registered: ${userCredential.user?.uid}');
                        await _firestore
                            .collection('users')
                            .doc(userCredential.user?.uid)
                            .set({
                          'email': _emailController.text,
                          'role': 'pencari_kos',
                          // Add other user details as needed
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration successful!'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Delay navigation back to login page for 2 seconds
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context); // Navigate back to login page
                        });
                      } catch (e) {
                        print('Error during registration: $e');

                        String errorMessage =
                            'An error occurred during registration.';

                        // Check if the error is related to email already in use
                        if (e is FirebaseAuthException &&
                            e.code == 'email-already-in-use') {
                          errorMessage =
                              'Email is already registered. Try using a different email.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
                    'Register',
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
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 14 * ffem,
                        color: Color.fromARGB(255, 50, 50, 50),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login now!',
                        style: TextStyle(
                          fontSize: 13 * ffem,
                          color: Color(0xff5843BE),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
