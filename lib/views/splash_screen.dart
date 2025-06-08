import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.pushReplacement(AppRoutes.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor,
                splashColor,
                primaryColor,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child: SizedBox(
                width: 250,
                height: 300,
                child: Image.asset('assets/images/logo2.png')),
          ),
        ),
      ),
    );
  }
}
