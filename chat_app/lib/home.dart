import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:local_auth/local_auth.dart';
import 'notes_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List colors = [
    Color.fromRGBO(25, 46, 91, 1),
    Color.fromRGBO(29, 101, 166, 1),
    Color.fromRGBO(114, 162, 192, 1),
    Color.fromRGBO(0, 116, 63, 1),
    Color.fromRGBO(242, 161, 4, 1),
  ];
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration:
          Duration(seconds: 1), // how long should the animation take to finish
    );
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.notes),
                
                  text: "Lockers",
                ),
                Tab(
                  text: "Task",
                  icon: Icon(Icons.timer),
                ),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 5,
              indicatorColor: colors[2],
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  tooltip: "Search",
                  onPressed: null)
            ],
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
                Text("Note",
                    style: GoogleFonts.montserratAlternates(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    )),
                Text(
                  "Share",
                  style: GoogleFonts.montserratAlternates(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            focusColor: Colors.white,
            child: AnimatedIcon(
              icon: AnimatedIcons
                  .add_event, // one of the available animated icons
              progress: _controller, // this is our AnimationController
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertBox();
                  });
            },
            backgroundColor: colors[2],
            splashColor: Colors.blue,
            hoverColor: Colors.red,
          ),
          body: TabBarView(
            children: [
              NotesHome(),
              Icon(Icons.directions_transit),
            ],
          )),
    );
  }
}
