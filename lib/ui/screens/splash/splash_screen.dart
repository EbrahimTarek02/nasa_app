import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nasa_app/ui/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {

  static const routeName  = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 6, milliseconds: 400),
      () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Center(
        child: Lottie.asset('assets/animation/Animation - 1696501126258.json'),
      ),
    );
  }
}
