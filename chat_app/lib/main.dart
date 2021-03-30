import 'dart:async';
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
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final number = TextEditingController();
  List directioncircle;

  List aligncircle = [
    Alignment.topCenter,
    Alignment.centerRight,
    Alignment.bottomCenter,
    Alignment.centerLeft
  ];

  String loading = '';

  List alignline = [
    Alignment.topLeft,
    Alignment.topRight,
  ];

  List customicon = [
    Icons.lock,
    Icons.vpn_key_sharp,
    Icons.account_balance_wallet,
    Icons.text_fields,
    Icons.notes
  ];

  List colors = [
    Color.fromRGBO(25, 46, 91, 1),
    Color.fromRGBO(29, 101, 166, 1),
    Color.fromRGBO(114, 162, 192, 1),
    Color.fromRGBO(0, 116, 63, 1),
    Color.fromRGBO(242, 161, 4, 1),
  ];
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  // ignore: non_constant_identifier_names
  double width_container = 0, bottomheight = 90;
  var xf = 1, temp = -0.4, result, exactval, warn;

  bool _visible = false,
      nobiometric = false,
      nextscreen = false,
      emptyornot,
      wrong = false,
      check = false,
      motion = false,
      change = false,
      _cont = false;
  String heading = '', secondarytext = '';

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
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
                          child: AnimatedSwitcher(
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                child: child,
                                scale: animation,
                              );
                            },
                            duration: Duration(milliseconds: 600),
                            child: Container(
                              key: UniqueKey(),
                              child: CircleAvatar(
                                backgroundColor: colors[xf],
                                child: Icon(customicon[xf],
                                    color: Colors.white, size: 30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Loading Lockers$loading",
                        style: GoogleFonts.montserratAlternates(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: AnimatedOpacity(
                  opacity: _cont ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width: MediaQuery.of(context).size.width * 0.25,
                          image: AssetImage('images/appicon/icon4.png'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AnimatedContainer(
                          width: MediaQuery.of(context).size.width *
                              width_container,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: colors[xf],
                            borderRadius: _borderRadius,
                          ),
                          // Define how long the animation should take.
                          duration: Duration(milliseconds: 1000),
                          // Provide an optional curve to make the animation feel smoother.
                          curve: Curves.ease,
                        ),
                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Note",
                              style: GoogleFonts.montserratAlternates(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 3,
                            ),
                            Text(
                              "Share",
                              style: GoogleFonts.montserratAlternates(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ],
                        ),
                        Text(
                          "Keep your Passwords handy",
                          style: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 3,
                        ), */
                      ],
                    ),
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  primary:Colors.blue,
                                   elevation: 10,
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ), 
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
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

  Future _query() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
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

  startcircleTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer.periodic(_duration, (timer) {
      if (nextscreen) {
        timer.cancel();
      } else {
        if (timer.tick == 1) {
          setState(() {
            xf = 0;
            _cont = true;
          });
        }
        xf++;
        setState(() {
          width_container = width_container - temp;
          temp = -temp;
          xf = xf % 5;
          loading.length == 3
              ? loading = ''
              : loading = loading.padRight(timer.tick % 4, '.');
        });
      }
    });
  }

  opaa() async {
    setState(() {
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
}
