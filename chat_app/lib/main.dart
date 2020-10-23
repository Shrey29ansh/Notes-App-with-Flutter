import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chat_app/home.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:chat_app/database_helper.dart';

void main() => runApp(new MaterialApp(
      home: new SplashScreen(),
    ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Random random = new Random();
  final dbHelper = mainDB.instance, number = TextEditingController();
  bool _visible = false,
      nobiometric = false,
      nextscreen = false,
      emptyornot,
      wrong = false,
      check = false;
  AlignmentDirectional _animatedcontainer = AlignmentDirectional(0.0, 0.7);
  String heading = '', secondarytext = '';
  var result, exactval, warn = null;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future _query() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
  }

  void _insert(String passcode) async {
    // row to insert
    Map<String, dynamic> row = {
      mainDB.columnName: '$passcode',
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to start using the app",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      setState(() {
        nextscreen = true;
      });
    }
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future startTimer() async {
    var _duration = new Duration(milliseconds: 300);
    return new Timer(_duration, opaa);
  }

  opaa() async {
    setState(() {
      _animatedcontainer = AlignmentDirectional(0.0, -0.7);
      _visible = true;
    });
  }

  navigationPage() async {
  
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
      if (nextscreen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else {
      print("hello");
      var value;
      value = await _query();
      if (value.isEmpty) {
        setState(() {
          exactval = null;
          heading = 'Welcome to the App';
          secondarytext = 'Set an app passcode to continue!';
          print("done");
          check = true;
        });
      } else {
        setState(() {
          exactval = value[0]['code'];
          heading = 'Welcome back';
          secondarytext = 'Enter passcode';
          print("done");
          check = true;
        });
      }
      startTimer();
      //Navigator.of(context).pushReplacement(_createRoute());
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 6000),
                alignment: _animatedcontainer,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notes,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "Note",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                      Text(
                        "Share",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              check
                  ? Align(
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: _visible ? 1 : 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "$heading",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "$secondarytext",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: TextField(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      obscureText: true,
                                      cursorColor: Colors.black,
                                      controller: number,
                                      autocorrect: true,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusColor: Colors.blue,
                                        errorText: warn,
                                        errorStyle: TextStyle(),
                                        hintText: "Enter PIN",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 5,
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.blue,
                                  onPressed: () {
                                    print(number.text);
                                    if (number.text.isEmpty) {
                                      setState(() {
                                        warn = "Pin is required";
                                      });
                                    } else {
                                      if (exactval == null) {
                                        _insert(number.text);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      } else {
                                        if (exactval == number.text) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            warn = 'Try Again!';
                                            wrong = true;
                                          });
                                        }
                                      }
                                    }
                                    number.clear();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
