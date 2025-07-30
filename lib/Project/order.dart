import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:Nikazhthi/sidedrawer.dart';
import 'edit_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appName = 'Event Details';

void main() => runApp(MaterialApp(
      title: appName,
      home: EventPage(),
    ));

class EventPage extends StatefulWidget {
  final String title;
  EventPage({Key key, this.title}) : super(key: key);
  @override
  EventPageState createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = '';
  List _event = [];
  @override
  initState() {
    super.initState();
    print(widget.title);
    getuname().then((value) {
      setState(() {
        _username = value;
      });
      getevent(widget.title.substring(10), widget.title.substring(0, 10))
          .then((value) {
        setState(() {
          _event = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: getsome(),
        builder: (context, _events) {
          if (_events.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              drawer: SideDrawer(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  var data2 = '${_event[1]}${_event[0]}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditOrder(title: data2)),
                  );
                },
                backgroundColor: Colors.deepOrange[500],
                tooltip: 'Edit Order',
                child: Icon(Icons.edit),
              ),
              appBar: PreferredSize(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top),
                  child: ButtonTheme.bar(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          elevation: 0,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Event Details',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      gradient: LinearGradient(
                          colors: [Colors.deepPurple, const Color(0xff0D37C1)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                        )
                      ]),
                ),
                preferredSize:
                    Size(MediaQuery.of(context).size.width, 150.0),
              ),
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
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Card(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white70)),
                          child: Center(
                            child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Text(
                                            ' ${_event[0]}  ',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Icon(
                                            _event[5] == true
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: _event[5] == true
                                                ? Colors.green
                                                : Colors.red,
                                            size: 25.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                      height: 0.0,
                                      indent: 15.0,
                                    ),
                                    ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.today,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          Text('  ${_event[1]}')
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.timer,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          Text('  ${_event[2]}-${_event[6]}')
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.map,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          Text('  ${_event[3]}')
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          Text('  ${_event[4]}')
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              drawer: SideDrawer(),
              appBar: PreferredSize(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top),
                  child: ButtonTheme.bar(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          elevation: 0,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Event Details',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      gradient: LinearGradient(
                          colors: [Colors.deepPurple, const Color(0xff0D37C1)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                        )
                      ]),
                ),
                preferredSize:
                    Size(MediaQuery.of(context).size.width, 150.0),
              ),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                      Text('Loading...')
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );

  Future<String> getuname() async {
    final prefs = await SharedPreferences.getInstance();
    final name = "username";
    var user = prefs.getString(name);
    var username = '${user[0].toUpperCase()}${user.substring(1)}';
    print('get $username');
    return username;
  }


  Future<List> getsome() async {
    var list = await getevent(_event[0], _event[1]);
    return list;
  }
  Future<List> getevent(String name, String date) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("${_username.toLowerCase()}-orders")
        .where('name', isEqualTo: name)
        .where('date', isEqualTo: date)
        .getDocuments();
    var doc = querySnapshot.documents;
    var list = [
      doc[0]['name'],
      doc[0]['date'],
      doc[0]['time'],
      doc[0]['address'],
      doc[0]['contact'],
      doc[0]['done'],
      doc[0]['endtime']
    ];
    return list;
  }
}
