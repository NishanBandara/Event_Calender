import 'dart:async';
import 'dart:ffi';

import 'package:event_calender/Colors/CustomColors.dart';
import 'package:event_calender/Screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 6),
        () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Center(
              child: SizedBox(
                height: 250,
                width: 300,
                child: Image.asset('images/Logo.PNG'),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator(
            color: primaryColor,
          ),
          SizedBox(
            height: 300,
          ),
        ],
      ),
    );
  }
}
