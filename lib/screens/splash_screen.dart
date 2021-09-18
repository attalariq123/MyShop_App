import 'package:flutter/material.dart';
import 'package:shop_app/constant.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeMedia = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: sizeMedia.width,
        height: sizeMedia.height,
        child: Center( 
          child: Text(
            'MyShop',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 30,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w900,
                  color: colorCustom,
                ),
          ),
        ),
      ),
    );
  }
}
