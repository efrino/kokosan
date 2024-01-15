import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LupaPassword extends StatefulWidget {
  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
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
                  Icons
                      .lock_outline, // Ganti dengan ikon yang sesuai, misalnya Icons.lock_outline
                  size: 120 * fem,
                  color: Colors
                      .blue, // Sesuaikan dengan warna ikon yang diinginkan
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
                    ],
                  ),
                ),
                SizedBox(height: 24 * fem),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        await _auth.sendPasswordResetEmail(
                          email: _emailController.text,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Password reset email sent. Check your inbox.',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        print('Error during password reset: $e');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error sending password reset email. Check your email address.',
                            ),
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
                    'Send Reset Email',
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
                      'Remembered your password?',
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
