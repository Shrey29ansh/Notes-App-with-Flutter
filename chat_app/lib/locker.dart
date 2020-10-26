import 'dart:async';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:chat_app/home.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/database_helper.dart';
import 'package:local_auth/local_auth.dart';

class Locker extends StatefulWidget {
  final lockername, password, username, comments, color;
  Locker(
      {this.lockername,
      this.comments,
      this.password,
      this.username,
      this.color});
  @override
  _LockerState createState() => _LockerState(
      lockername: lockername,
      username: username,
      password: password,
      comments: comments,
      color: color);
}

class _LockerState extends State<Locker> {
  final lockername, password, username, comments, color;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  _LockerState(
      {this.lockername,
      this.comments,
      this.password,
      this.username,
      this.color});
  final dbHelper = mainDB.instance, number = TextEditingController();

  bool nextscreen = false;
  bool show = false;
  Future _query() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
  }

  bool wrong = false, _visible = false;
  // ignore: avoid_init_to_null
  var warn = null;
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

  bool showcont = false;

  Future<void> _checkpin() async {
    var value;
    value = await _query();
    setState(() {
      exactval = value[0]['code'];
      showcont = true;
    });
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

  var exactval;
  void checklock() async {
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
      if (nextscreen) {
        setState(() {
          show = true;
        });
      }
    } else {
      setState(() {
        showcont = true;
      });
      startTimer();
      //Navigator.of(context).pushReplacement(_createRoute());
    }
  }

  @override
  void initState() {
    this.checklock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            show
                ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.width * .9,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_open,
                                    size: 50,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Locker: $lockername",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                      overflow: TextOverflow.clip,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    "Username: $username\nPassword: $password\nComments: $comments",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : showcont
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Enter Pin",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
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
                                      onPressed: () async {
                                        print(number.text);
                                        if (number.text.isEmpty) {
                                          setState(() {
                                            warn = "Pin is required";
                                          });
                                        } else {
                                          await _checkpin();
                                          if (exactval == number.text) {
                                            setState(() {
                                              show = true;
                                            });
                                          } else {
                                            setState(() {
                                              warn = 'Try Again!';
                                              wrong = true;
                                            });
                                          }
                                        }

                                        number.clear();
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
