import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chat_app/home.dart';

void main() => runApp(new MaterialApp(
      home: new SplashScreen(),
    ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Random random = new Random();

  int index = 0;
  int indexe = 0;
  List colors = [Colors.red, Colors.blue, Colors.yellow];

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                      Icons.notes,
                      color: Colors.red,
                      size: 50,
                    ),
                
                Text(
                  "Note",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Text(
                  "Share",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
