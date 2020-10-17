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
  final dbHelper = mainDB.instance;
  final number = TextEditingController();

  bool _visible = false;

  String heading = '';
  String secondarytext = '';
  bool nobiometric = false;
  bool nextscreen = false;
  bool emptyornot;
  var result;
  var exactval;
  bool wrong = false;
  String warn = 'Try Again!';

  bool check = false;
  double _left = 20;
  double _top = 20;
  double _right = 20;
  double _bottom = 20;
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
        localizedReason:
            "Please authenticate to view your transaction overview",
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
      _visible = true;
    });
  }

  navigationPage() async {
    //_insert('1234');
    //_delete();
    setState(() {
      _bottom = 500;
    });
    if (!await _isBiometricAvailable()) {
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
          heading = 'Please Enter passcode to continue';
          secondarytext = '';
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Stack(
          children: [
            check
                ? Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _visible ? 1 : 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "$heading",
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                "$secondarytext",
                                style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Card(
                                  child: TextField(
                                    controller: number,
                                    autocorrect: true,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Do remember this thing..",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: Colors.amber,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              wrong
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$warn",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        warn == "required*"
                                            ? Container()
                                            : Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              )
                                      ],
                                    )
                                  : Container(),
                              RaisedButton(
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
                                      warn = "required*";
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastOutSlowIn,
              left: _left,
              top: _top,
              right: _right,
              bottom: _bottom,
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
