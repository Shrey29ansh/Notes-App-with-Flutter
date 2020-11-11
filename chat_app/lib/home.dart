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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int tabnumber = 0;
  List colors = [
    Color.fromRGBO(25, 46, 91, 1),
    Color.fromRGBO(29, 101, 166, 1),
    Color.fromRGBO(114, 162, 192, 1),
    Color.fromRGBO(0, 116, 63, 1),
    Color.fromRGBO(242, 161, 4, 1),
  ];
  TabController _tabController;
  void _handletab() {
    setState(() {
      tabnumber = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.animation.addListener(_handletab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: new Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.06),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: "Lockers",
                    ),
                    Tab(
                      text: "Task",
                    ),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 1,
                  indicatorColor: colors[2],
                  indicatorPadding: EdgeInsets.all(10),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[700],
                ),
              ),
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
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    child: child,
                    scale: animation,
                  );
                },
                child: Container(
                  key: UniqueKey(),
                  child: tabnumber == 0
                      ? IconButton(
                          icon: Icon(
                            Icons.note_add_outlined,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.add_alert,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null,
                        ),
                )),
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
            controller: _tabController,
            children: [
              NotesHome(),
              Container(
                color: Colors.black,
              )
            ],
          )),
    );
  }
}
