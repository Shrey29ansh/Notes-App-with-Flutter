import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chat_app/home.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final dbHelper = mainDB.instance;
  List directioncircle;
  List aligncircle = [
    Alignment.topCenter,
    Alignment.centerRight,
    Alignment.bottomCenter,
    Alignment.centerLeft
  ];
  List alignline = [
    Alignment.topLeft,
    Alignment.topRight,
  ];
  Random random = new Random();
  final number = TextEditingController();
  bool _visible = false,
      nobiometric = false,
      nextscreen = false,
      emptyornot,
      wrong = false,
      check = false;
  AlignmentDirectional _animatedcontainer = AlignmentDirectional(0.0, 0.7);
  String heading = '', secondarytext = '';
  // ignore: avoid_init_to_null
  var result, exactval, warn = null;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _cont = false;
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
    setState(() {});
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  Future startTimer() async {
    var _duration = new Duration(milliseconds: 300);
    return new Timer(_duration, opaa);
  }

  var o = 0, t = 1, th = 2, f = 3, lined = 0;
  startcircleTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer.periodic(_duration, (timer) {
      if (nextscreen) {
        timer.cancel();
      } else {
        if (timer.tick == 1) {
          setState(() {
            _cont = true;
          });
        }
        setState(() {
          o = (o + 1) % 4;
          t = (t + 1) % 4;
          th = (th + 1) % 4;
          f = (f + 1) % 4;
          lined = (lined + 1) % 2;
        });
      }
    });
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
    startcircleTime();
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
              AnimatedOpacity(
                opacity: _cont ? 1 : 0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text("Note",
                          style: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30,
                          )),
                      Text(
                        "Share",
                        style: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.37,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        curve: Curves.easeOutQuint,
                        alignment: aligncircle[o],
                        duration: Duration(milliseconds: 700),
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.vpn_key,
                            )),
                      ),
                      AnimatedContainer(
                        curve: Curves.easeOutQuint,
                        alignment: aligncircle[t],
                        duration: Duration(milliseconds: 700),
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.tealAccent[800],
                            child: Icon(
                              Icons.notes_sharp,
                              color: Colors.white,
                            )),
                      ),
                      AnimatedContainer(
                        curve: Curves.easeOutQuint,
                        alignment: aligncircle[th],
                        duration: Duration(milliseconds: 700),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromRGBO(187, 34, 5, 1),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        curve: Curves.easeOutQuint,
                        alignment: aligncircle[f],
                        duration: Duration(milliseconds: 700),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromRGBO(246, 131, 15, 1),
                          child: Icon(Icons.lock, color: Colors.white),
                        ),
                      )
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
