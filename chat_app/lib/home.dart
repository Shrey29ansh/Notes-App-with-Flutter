import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
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
        ));
  }
}

class AlertBox extends StatefulWidget {
  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  final nametext = TextEditingController(),
      username = TextEditingController(),
      password = TextEditingController(),
      comments = TextEditingController();
  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Text(
              "Create new locker",
              style: TextStyle(),
            ),
            Icon(Icons.lock),
          ],
        ),
      ),
      content: new Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Name of locker*"),
              TextField(
                cursorHeight: 20,
                onTap: () {
                  setState(() {});
                },
                cursorColor: Colors.black,
                controller: nametext,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusColor: Colors.blue,
                  prefixIcon: Icon(Icons.phonelink_lock),
                  errorStyle: TextStyle(),
                  hintText: "eg.Main Account",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Username/Email*"),
              TextField(
                cursorHeight: 20,
                onTap: () {
                  setState(() {});
                },
                cursorColor: Colors.black,
                controller: username,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  focusColor: Colors.blue,
                  errorStyle: TextStyle(),
                  hintText: "Mainaccount@x.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Password*"),
                ],
              ),
              TextField(
                cursorHeight: 20,
                cursorColor: Colors.black,
                controller: password,
                obscureText: !visibility,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
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
                  focusColor: Colors.blue,
                  errorStyle: TextStyle(),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Comments (optional)"),
              TextField(
                cursorHeight: 20,
                onTap: () {
                  setState(() {});
                },
                cursorColor: Colors.black,
                controller: comments,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusColor: Colors.blue,
                  errorStyle: TextStyle(),
                  hintText: "Extra Info",
                  prefixIcon: Icon(Icons.comment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RaisedButton(
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
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
