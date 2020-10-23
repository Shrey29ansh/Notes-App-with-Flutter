import 'dart:async';

import 'package:chat_app/locker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: unused_import
import 'package:local_auth/local_auth.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

StreamController _streamController;
Stream _stream;

Stream getList() async* {
  try {
    final dbHelper = CreateNotes.instance;
    final allRows = await dbHelper.queryAllRows();
    print(allRows);
    _streamController.add(allRows);
  } catch (e) {
    print(e);
  }
}

class _HomePageState extends State<HomePage> {
  int colorindex = 0;
  final dbHelper = CreateNotes.instance;

  List colors = [
    Colors.blueAccent,
    Colors.deepOrange,
    Colors.blue[800],
    Colors.red[900],
    Colors.teal
  ];

  @override
  void initState() {
    getList().listen((event) {
      print(event);
    });
    _streamController = StreamController();
    _stream = _streamController.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('NoteShare'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertBox();
                });
          },
          backgroundColor: Colors.amber,
          splashColor: Colors.yellow,
          hoverColor: Colors.red,
        ),
        body: Container(
          color: Colors.black,
          child: StreamBuilder(
            stream: _stream,
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                print("nothing");
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.grey[600],
                        size: MediaQuery.of(context).size.width * 0.7,
                      ),
                      Text(
                        "Empty Locker",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  ),
                );
              }
              return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    bool checkval = true;
                    if (index > 4) {
                      colorindex = index % 5;
                      checkval = false;
                    }
                    return Container(
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 25,
                                      color: checkval
                                          ? colors[index]
                                          : colors[colorindex],
                                    ),
                                  ],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              splashColor: Colors.blue,
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Locker(
                                        lockername: snapshot.data[index]
                                            ['lockername'],
                                        username: snapshot.data[index]
                                            ['username'],
                                        password: snapshot.data[index]
                                            ['password'],
                                        comments: snapshot.data[index]
                                            ['comments'],
                                        color: checkval
                                            ? colors[index]
                                            : colors[colorindex],
                                      ),
                                    ));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 2,
                                  shadowColor: checkval
                                      ? colors[index]
                                      : colors[colorindex],
                                  color: checkval
                                      ? colors[index]
                                      : colors[colorindex],
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 1,
                                        right: 20,
                                        child: Icon(
                                          Icons.vpn_key,
                                          size: 150,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '${snapshot.data[index]['lockername']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ));
  }
}

class AlertBox extends StatefulWidget {
  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  final _formKey = GlobalKey<FormState>();
  bool namerror = false,
      usererror = false,
      passerror = false,
      mandatory = false; // for locker name validation
  var warning, mandatwarning;
  final nametext = TextEditingController(),
      username = TextEditingController(),
      password = TextEditingController(),
      comments = TextEditingController();
  FocusNode _myfocus = FocusNode(),
      namefocus = FocusNode(),
      passfocus = FocusNode(),
      comfocus = FocusNode();
  bool visibility = false;
  bool touched = false;

  void changefocus() async {
    if (!_myfocus.hasFocus) {
      var check = await checklocker(nametext.text);
      if (check == null) {
        setState(() {
          namerror = false;
        });
      } else {
        if (!check.isEmpty) {
          setState(() {
            namerror = true;
            warning = "This Lockername already exist";
          });
        } else {
          setState(() {
            namerror = false;
          });
        }
      }
    }
  }

  Future checklocker(String lockername) async {
    //final ffr = await dbHelper.delete('gmail');
    try {
      final dbHelper = CreateNotes.instance;
      final result = await dbHelper.checkName(lockername);
      return result;
    } catch (e) {
      print(e);
    }
  }

  Future insertNotes(String namefield, String usernamefield,
      String passwordfield, String commentsfield) async {
    final dbHelper = CreateNotes.instance;

    Map<String, dynamic> row = {
      CreateNotes.columnName: namefield,
      CreateNotes.columnUsername: usernamefield,
      CreateNotes.password: passwordfield,
      CreateNotes.comments: commentsfield
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _requestFocus(FocusNode name) {
    setState(() {
      touched = true;
      FocusScope.of(context).requestFocus(name);
    });
  }

  @override
  void initState() {
    super.initState();
    _myfocus.addListener(changefocus);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black.withOpacity(0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        color: Colors.red,
                      ),
                      new Text(
                        "Create new locker",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                AlertDialog(
                  buttonPadding: EdgeInsets.all(10),
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  actions: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 5,
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.grey[900],
                      onPressed: () async {
                        if (_myfocus.hasFocus) {
                          var check = await checklocker(nametext.text);

                          if (check == null) {
                            setState(() {
                              namerror = false;
                            });
                          } else {
                            if (!check.isEmpty) {
                              setState(() {
                                namerror = true;
                                warning = "This Lockername already exist";
                              });
                            } else {
                              setState(() {
                                namerror = false;
                              });
                            }
                          }
                        }
                        if (_formKey.currentState.validate()) {
                          if (!namerror) {
                            //logic for db entry
                            try {
                              await insertNotes(nametext.text, username.text,
                                  password.text, comments.text);
                              final dbHelper = CreateNotes.instance;
                              final allRows = await dbHelper.queryAllRows();
                              _streamController.add(allRows);
                            } catch (e) {
                              print(e);
                            }
                          }
                        } else {
                          print("false");
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 5,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.grey[900],
                      onPressed: () {
                        /* print(nametext.text);
                        print(password.text);
                        print(comments.text);
                        print(username.text); */

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: new Container(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
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
                                _requestFocus(_myfocus);
                              },
                              cursorColor: Colors.black,
                              controller: nametext,
                              focusNode: _myfocus,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelText: "Name of locker*",
                                  errorText: namerror ? warning : null,
                                  labelStyle: TextStyle(
                                      color: touched
                                          ? Colors.black
                                          : Colors.grey[500]),
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[500]),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  focusColor: Colors.white,
                                  errorStyle: TextStyle(),
                                  hintText: "eg.Main Account",
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'required*';
                                }
                              },
                              enableSuggestions: true,
                              style: TextStyle(color: Colors.black),
                              cursorHeight: 20,
                              onTap: () {
                                _requestFocus(namefocus);
                              },
                              cursorColor: Colors.black,
                              controller: username,
                              focusNode: namefocus,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelText: "Username/Email*",
                                  labelStyle: TextStyle(
                                      color: touched
                                          ? Colors.black
                                          : Colors.grey[500]),
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[500]),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  focusColor: Colors.white,
                                  errorStyle: TextStyle(),
                                  hintText: "eg.a@xmail.com",
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'required*';
                                }
                              },
                              obscureText: !visibility,
                              style: TextStyle(color: Colors.black),
                              cursorHeight: 20,
                              onTap: () {
                                _requestFocus(passfocus);
                              },
                              cursorColor: Colors.black,
                              controller: password,
                              focusNode: passfocus,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelText: "Password*",
                                  errorText: passerror ? warning : null,
                                  suffixIcon: visibility
                                      ? InkWell(
                                          child: Icon(
                                            Icons.visibility_off,
                                            color: Colors.grey[500],
                                          ),
                                          onTap: () => setState(() {
                                                visibility = !visibility;
                                              }))
                                      : InkWell(
                                          child: Icon(Icons.visibility),
                                          onTap: () => setState(() {
                                                visibility = !visibility;
                                              })),
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[500]),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  focusColor: Colors.white,
                                  errorStyle: TextStyle(),
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.black),
                              cursorHeight: 20,
                              onTap: () {
                                _requestFocus(comfocus);
                              },
                              cursorColor: Colors.black,
                              controller: comments,
                              focusNode: comfocus,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelText: "Extra Info",
                                  labelStyle: TextStyle(
                                      color: touched
                                          ? Colors.black
                                          : Colors.grey[500]),
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[500]),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  focusColor: Colors.white,
                                  errorStyle: TextStyle(),
                                  hintText: "eg.Main Account",
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
