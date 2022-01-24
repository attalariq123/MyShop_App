import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCustom,
      body: Center(
          child: !kIsWeb
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: new Image.asset(
                        "assets/images/farmer_ccexpress.png",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Text(
                      'TaniKu',
                      style: GoogleFonts.poppins(
                        fontSize: 44,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new Image.asset(
                      "assets/images/farmer_ccexpress.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    'TaniKu',
                    style: GoogleFonts.poppins(
                      fontSize: 44,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ])),
    );
  }
}
