import 'package:flutter/material.dart';
import 'Project/add_order.dart';
import 'Project/done_pro.dart';
import 'Project/notdone_pro.dart';
import 'Project/home.dart';
import 'Project/today.dart';
import 'Login/mlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'Project/calender.dart';
import 'Project/requests.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String _username = '';
  String email = '';
  List ordname = [];
  int counter = 0;
  @override
  initState() {
    super.initState();
    getuname().then((value) {
      setState(() {
        _username = value[0];
        email = value[1];
      });
      getlist().then((value) {
        setState(() {
          ordname = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
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
            Colors.deepPurple,
            Colors.purple,
            Colors.deepPurpleAccent,
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data[0]);
                else
                  return Text('');
              },
              future: getuname(),
            ),
            accountEmail: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data[1]);
                else
                  return CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  );
              },
              future: getuname(),
            ),
            otherAccountsPictures: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<bool>(builder: (context) => AddOrder()),
                    );
                  })
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
            leading: Icon(Icons.event),
            title: Text("Calender"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodayPage()),
              );
            },
            leading: Icon(Icons.today),
            title: Text('Today Orders'),
          ),
          ListTile(
              leading: Icon(Icons.done_outline),
              title: Text("Completed Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonePage()),
                );
              }),
          ListTile(
              leading: Icon(CupertinoIcons.clear_thick),
              title: Text("Not Completed Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotDonePage()),
                );
              }),
          ListTile(
              leading: Icon(Icons.playlist_add_check),
              title: Text("Requested Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestPage()),
                );
              }),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainLogin()),
              );
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          ),
        ],
      ),
    ));
  }

  Future<List> getuname() async {
    final prefs = await SharedPreferences.getInstance();
    final name = "username";
    var user = prefs.getString(name);
    var username = '${user[0].toUpperCase()}${user.substring(1)}';
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .where('username', isEqualTo: username.toLowerCase())
        .getDocuments();
    var email;
    if (querySnapshot.documents.isNotEmpty) {
      email = querySnapshot.documents[0]['email'];
    } else {
      QuerySnapshot querySnapshot2 = await Firestore.instance
          .collection("users")
          .where('username', isEqualTo: username.toLowerCase())
          .getDocuments();
      email = querySnapshot2.documents[0]['email'];
    }
    var list = [username, email];
    return list;
  }

  Future<List> getlist() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("${_username.toLowerCase()}-orders")
        .getDocuments();
    var list = List.generate(querySnapshot.documents.length,
        (int index) => querySnapshot.documents[index]['date']);
    return list;
  }
}
