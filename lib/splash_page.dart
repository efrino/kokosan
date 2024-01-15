import 'package:mobile_kokosan/opsi-masuk.dart';
import 'package:flutter/material.dart';
import 'package:mobile_kokosan/theme.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/splash_image.png'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo2.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Find Cozy House\nto Stay and Happy',
                      style: blackTextStyle.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Stop membuang banyak waktu\npada tempat yang tidak habitable',
                      style: greyTextStyle.copyWith(
                        fontSize: 16,
                        color: Color.fromARGB(255, 24, 0,
                            109), // Ganti dengan warna yang diinginkan
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 210,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => opsiMasuk()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: purpleColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            )), // background

                        child: Text(
                          'Login Now',
                          style: whiteTextStyle.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
