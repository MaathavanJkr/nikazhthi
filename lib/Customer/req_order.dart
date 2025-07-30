import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appName = 'Request Order';

void main() => runApp(MaterialApp(
      title: appName,
      home: ReqOrder(),
    ));

class ReqOrder extends StatefulWidget {
  final String title;
  ReqOrder({Key key, this.title}) : super(key: key);
  @override
  ReqOrderState createState() => ReqOrderState();
}

class ReqOrderState extends State<ReqOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _admin = '';
  String _username = '';
  String _date = '';
  @override
  
  initState() {
    getuname().then((value) {
      setState(() {
        _username = value;
      });
    });
    _admin = widget.title.substring(10);
    _date = widget.title.substring(0, 10);

    super.initState();
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
  DateTime date;
  DateTime time;
  DateTime etime;

  final myControllerName = TextEditingController();
  final myControllerCNo = TextEditingController();
  final myControllerCAd = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myControllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                    'Request Order',
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
                    colors: [Colors.deepPurpleAccent, const Color(0xff0D37C1)]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  )
                ]),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
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
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Name $_username';
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
                      keyboardType: TextInputType.number,
                      inputType: inputType2,
                      format: formats[inputType2],
                      editable: editable,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          labelText: 'Start Time',
                          hasFloatingPlaceholder: true),
                      onChanged: (dt2) => setState(() => time = dt2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: DateTimePickerFormField(
                      keyboardType: TextInputType.number,
                      inputType: inputType2,
                      format: formats[inputType2],
                      editable: editable,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          labelText: 'End Time',
                          hasFloatingPlaceholder: true),
                      onChanged: (dt2) => setState(() => etime = dt2),
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
          onPressed: () {
            Firestore.instance
                .collection('${_admin.toLowerCase()}-orders')
                .document()
                .setData({
              'name': myControllerName.text,
              'contact': myControllerCNo.text,
              'address': myControllerCAd.text,
              'date': _date,
              'time': DateFormat('kk:mm').format(time),
              'endtime': DateFormat('kk:mm').format(etime),
              'done': false,
              'approved': false
            });
            return showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text("Success"),
                    content: Text("Order Requested Successfully."),
                    actions: <Widget>[
                      CupertinoDialogAction(
                          child: const Text('Done'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchList()),
                            );
                          }),
                    ],
                  );
                });
          },
          tooltip: 'Request Order',
          child: Icon(Icons.send),
        ),
      );

Future<String> getuname() async {
  final prefs = await SharedPreferences.getInstance();
  final name = "username";
  var user = prefs.getString(name);
  var username = '${user[0].toUpperCase()}${user.substring(1)}';
  print('get $username');
  return username;
}
}

