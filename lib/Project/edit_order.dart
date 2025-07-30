import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Nikazhthi/Project/notdone_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:Nikazhthi/sidedrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appName = 'Edit Order';

void main() => runApp(MaterialApp(
      title: appName,
      home: EditOrder(),
    ));

class EditOrder extends StatefulWidget {
  final String title;
  EditOrder({Key key, this.title}) : super(key: key);
  @override
  EditOrderState createState() => EditOrderState();
}

class EditOrderState extends State<EditOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = '';

  TextEditingController myControllerName;
  TextEditingController myControllerCNo;
  TextEditingController myControllerCAd;
  TextEditingController myControllerDate;
  TextEditingController myControllerTime;
  TextEditingController myControllerETime;
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
        myControllerName = TextEditingController(text: _event[0]);
        myControllerCNo = TextEditingController(text: _event[4]);
        myControllerCAd = TextEditingController(text: _event[3]);
        myControllerDate = TextEditingController(text: _event[1]);
        myControllerTime = TextEditingController(text: _event[2]);
        myControllerETime = TextEditingController(text: _event[6]);
      });
    });
  }

  // Show some different formats.
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.date;
  InputType inputType2 = InputType.time;
  bool editable = true;
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myControllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: getsome(),
        builder: (context, _events) {
          if (_events.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomPadding: false,
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
                            size: 35.0,
                          ),
                          elevation: 0,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Edit Order',
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
                      gradient: LinearGradient(colors: [
                        Colors.deepPurpleAccent,
                        const Color(0xff0D37C1)
                      ]),
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
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Editing ${_event[0]}\'s Order',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                          height: 0.0,
                          indent: 15.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                hintText: 'Name'),
                            controller: myControllerName,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Contact No.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                hintText: 'Contact Number'),
                            controller: myControllerCNo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.map,
                                  color: Colors.white,
                                ),
                                hintText: 'Address'),
                            controller: myControllerCAd,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: DateTimePickerFormField(
                            initialDate: DateTime.parse(_event[1]),
                            controller: myControllerDate,
                            keyboardType: TextInputType.number,
                            inputType: inputType,
                            format: formats[inputType],
                            editable: editable,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                                labelText: 'Date',
                                hasFloatingPlaceholder: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: DateTimePickerFormField(
                            initialTime: TimeOfDay.fromDateTime(DateTime.parse(
                                '${_event[1]} ${_event[2]}:00Z')),
                            inputType: inputType2,
                            keyboardType: TextInputType.number,
                            controller: myControllerTime,
                            format: formats[inputType2],
                            editable: editable,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                labelText: 'Start Time',
                                hasFloatingPlaceholder: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: DateTimePickerFormField(
                            initialTime: TimeOfDay.fromDateTime(DateTime.parse(
                                '${_event[1]} ${_event[6]}:00Z')),
                            inputType: inputType2,
                            keyboardType: TextInputType.number,
                            controller: myControllerETime,
                            format: formats[inputType2],
                            editable: editable,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                labelText: 'End Time',
                                hasFloatingPlaceholder: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                // When the user presses the button, show an alert dialog with the
                // text the user has typed into our text field.
                backgroundColor: Colors.deepOrange[500],
                onPressed: () async {
                  QuerySnapshot querySnapshot = await Firestore.instance
                      .collection("${_username.toLowerCase()}-orders")
                      .where('name', isEqualTo: _event[0])
                      .where('date', isEqualTo: _event[1])
                      .getDocuments();
                  var doc = querySnapshot.documents;
                  await doc[0].reference.updateData({
                    'name': myControllerName.text,
                    'contact': myControllerCNo.text,
                    'address': myControllerCAd.text,
                    'date': myControllerDate.text,
                    'time': myControllerTime.text,
                    'done': _event[5],
                  });
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("Success"),
                          content: Text("Order Successfully Created."),
                          actions: <Widget>[
                            CupertinoDialogAction(
                                child: const Text('Done'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotDonePage()),
                                  );
                                }),
                          ],
                        );
                      });
                },
                tooltip: 'Edit Order',
                child: Icon(Icons.send),
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
