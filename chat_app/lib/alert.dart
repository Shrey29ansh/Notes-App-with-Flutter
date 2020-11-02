import 'dart:async';
import 'package:flutter/material.dart';


class EditAlert extends StatefulWidget {
  final lockername;
  EditAlert({this.lockername});
  @override
  _EditAlertState createState() => _EditAlertState(lockername: lockername);
}

class _EditAlertState extends State<EditAlert> {
  final lockername;
  _EditAlertState({this.lockername});
  double _showalert = 0;
  Future editnotes() async{
    
  } 
  startTImer() {
    var duration = Duration(microseconds: 100);
    return new Timer(duration, () {
      setState(() {
        _showalert = 30;
      });
    });
  }

  @override
  void initState() {
    startTImer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedPositioned(
        bottom: _showalert,
        curve: Curves.ease,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Are you sure you want to delete this locker?"),
              content: Text(
                "There is no backup!",
                style: TextStyle(color: Colors.grey[600]),
              ),
              actionsPadding: EdgeInsets.all(10),
              actions: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 5,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.grey[900],
                  onPressed: () {},
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
