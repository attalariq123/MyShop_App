import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: new Image.asset(
                "assets/images/farmer_ccexpress.png",
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'TaniKu',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontSize: 44,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
