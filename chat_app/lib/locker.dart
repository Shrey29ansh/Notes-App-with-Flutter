import 'dart:async';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:chat_app/home.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/database_helper.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import 'notes_tab.dart';

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
  double _bottom = -60;
  bool nextscreen = false;
  bool show = false;
  bool wrong = false, _visible = false;
  final _formKey = GlobalKey<FormState>();
  final nametext = TextEditingController(),
      usertext = TextEditingController(),
      passtext = TextEditingController(),
      comtext = TextEditingController();
  FocusNode _myfocus = FocusNode(),
      namefocus = FocusNode(),
      passfocus = FocusNode(),
      comfocus = FocusNode();
  bool _submit = false;
  Future _query() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
  }

  void _requestFocus(FocusNode name) {
    setState(() {
      FocusScope.of(context).requestFocus(name);
    });
  }

  Future editnotes() async {}

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
        localizedReason: "Please authenticate",
        androidAuthStrings: AndroidAuthMessages(
            signInTitle: "Locked :(",
            fingerprintRequiredTitle: "Hello",
            fingerprintHint: "Don't Press back button",
            fingerprintNotRecognized: "Not Recognised,Try Again!",
            cancelButton: "Cancel",
            fingerprintSuccess: "Suuccess"),
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

  Future startTimer2() async {
    var _duration = new Duration(milliseconds: 300);
    return new Timer(_duration, opaa2);
  }

  opaa2() async {
    setState(() {
      _bottom = 60;
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
        startTimer2();
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
        child: show
            ? Stack(
                children: [
                  /*
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$lockername",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                            overflow: TextOverflow.clip,
                            maxLines: 3,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            Icons.vpn_key,
                            size: 40,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardsBox(
                                  text: "Username:",
                                  richtext: true,
                                ),
                                AnimatedSwitcher(
                                    duration: Duration(milliseconds: 200),
                                    child: _submit
                                        ? TextFormField(
                                            // ignore: missing_return
                                            validator: (value) {
                                              print(value);
                                              if (value.isEmpty) {
                                                return 'required';
                                              }
                                            },
                                            style:
                                                TextStyle(color: Colors.black),
                                            cursorHeight: 20,
                                            onTap: () {
                                              _requestFocus(namefocus);
                                            },
                                            cursorColor: Colors.black,
                                            controller: usertext,
                                            focusNode: namefocus,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                                labelText: "Old:$username",
                                                enabledBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[500]),
                                                ),
                                                focusedBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                ),
                                                focusColor: Colors.white,
                                                errorStyle: TextStyle(),
                                                hintText: "eg.Main Account",
                                                hintStyle: TextStyle(
                                                    color: Colors.white)),
                                          )
                                        : CardsBox(
                                            text: username,
                                            richtext: false,
                                          )),
                                Divider(
                                  height: 10,
                                  thickness: 1,
                                  color: Colors.grey[900],
                                ),
                                CardsBox(
                                  text: "Password:",
                                  richtext: true,
                                ),
                                _submit
                                    ? Container(
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                          // ignore: missing_return
                                          validator: (value) {
                                            print(value);
                                            if (value.isEmpty) {
                                              return 'required';
                                            }
                                          },
                                          style: TextStyle(color: Colors.black),
                                          cursorHeight: 20,
                                          onTap: () {
                                            _requestFocus(passfocus);
                                          },
                                          cursorColor: Colors.black,
                                          controller: passtext,
                                          focusNode: passfocus,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              labelText: "Old:$password",
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[500]),
                                              ),
                                              focusedBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2),
                                              ),
                                              focusColor: Colors.white,
                                              errorStyle: TextStyle(),
                                              hintText: "eg.Main Account",
                                              hintStyle: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      )
                                    : CardsBox(
                                        text: password,
                                        richtext: false,
                                      ),
                                Divider(
                                  height: 10,
                                  thickness: 1,
                                  color: Colors.grey[900],
                                ),
                                CardsBox(
                                  text: "Comments",
                                  richtext: true,
                                ),
                                _submit
                                    ? Container(
                                        padding: EdgeInsets.all(8),
                                        child: TextFormField(
                                          // ignore: missing_return
                                          validator: (value) {
                                            print(value);
                                            if (value.isEmpty) {
                                              return 'required';
                                            }
                                          },
                                          style: TextStyle(color: Colors.black),
                                          cursorHeight: 20,
                                          onTap: () {
                                            _requestFocus(comfocus);
                                          },
                                          cursorColor: Colors.black,
                                          controller: comtext,
                                          focusNode: comfocus,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              labelText: "Old:$comments",
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[500]),
                                              ),
                                              focusedBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2),
                                              ),
                                              focusColor: Colors.white,
                                              errorStyle: TextStyle(),
                                              hintText: "eg.Main Account",
                                              hintStyle: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      )
                                    : CardsBox(
                                        text: comments,
                                        richtext: false,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: AnimatedOpacity(
                          opacity: _submit ? 1 : 0,
                          curve: Curves.decelerate,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            child: RaisedButton(
                                elevation: 10,
                                splashColor: Colors.deepOrange,
                                color: Colors.green,
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _bottom = 60;
                                    _submit = false;
                                  });
                                }),
                          ),
                        ),
                      )
                    ],
                  ), */

                  Positioned(
                      top: -50,
                      right: 0,
                      child: ClipRRect(
                        child: Icon(
                          Icons.vpn_key,
                          size: 500,
                          color: Colors.amber,
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                username[0],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 80,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Align(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    bottom: _bottom,
                    right: MediaQuery.of(context).size.width * 0.37,
                    curve: Curves.easeOutQuart,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              elevation: 10,
                              color: Colors.black.withOpacity(0.5),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        child: DeleteAlert(
                                          lockername: lockername,
                                        ),
                                      );
                                    });
                              },
                            ),
                            /* SizedBox(
                              width: 5,
                            ),
                            RaisedButton(
                              elevation: 10,
                              color: Colors.black.withOpacity(0.5),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _submit = true;
                                  _bottom = -60;
                                });
                              },
                            ), */
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                width: MediaQuery.of(context).size.width * 0.7,
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
                : Container(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

class CardsBox extends StatelessWidget {
  final text;
  final bool richtext;
  CardsBox({this.text, this.richtext});
  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      style: TextStyle(
          color: richtext ? Colors.black : Colors.grey[800],
          fontWeight: /* richtext ?  */ FontWeight
              .bold /* : FontWeight.normal */,
          fontSize: 18),
    );
  }
}
