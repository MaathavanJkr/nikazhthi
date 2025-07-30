import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:Nikazhthi/Customer/clogin.dart';

class MainLogin extends StatefulWidget {
  static const String routeName = 'cupertino/segmented_control';

  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold),),
    1: Text('Admin', style: TextStyle(fontWeight: FontWeight.bold),),
  };


  int sharedValue = 0;

  @override
  Widget build(BuildContext context)  => Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.4, 0.7, 1.0],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                const Color(0xff0D37C1),
                Colors.deepPurpleAccent,
                Colors.deepPurple,
                Colors.purple,
              ],
            ),
          ),
          child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold),)),
                Tab(child: Text('Owners', style: TextStyle(fontWeight: FontWeight.bold),)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CustLoginPage(),
              LoginPage(),
            ],
          ),
        ),
      ),
        ),
      );
  
}