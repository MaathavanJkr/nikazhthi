import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_order.dart';
import 'order.dart';
import 'package:Nikazhthi/sidedrawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double PADDING_TINY = 2.0;
const double PADDING_VERY_SMALL = 4.0;
const double PADDING_SMALL = 8.0;
const double PADDING_MEDIUM = 16.0;
const double PADDING_LARGE = 24.0;
const double PADDING_VERY_LARGE = 32.0;

const double FONT_VERY_SMALL = 4.0;
const double FONT_SMALL = 8.0;
const double FONT_MEDIUM = 16.0;
const double FONT_LARGE = 24.0;
const double FONT_VERY_LARGE = 32.0;

//For Task Row
const double FONT_SIZE_TITLE = 16.0;
const double FONT_SIZE_LABEL = 14.0;
const double FONT_SIZE_DATE = 12.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      home: NextDaysPage(),
    );
  }
}

class NextDaysPage extends StatefulWidget {
  @override
  _NextDaysPageState createState() {
    return _NextDaysPageState();
  }
}

class _NextDaysPageState extends State<NextDaysPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = '';
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String seday = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7)));
  @override
  initState() {
    super.initState();
    getuname().then((value) {
      setState(() {
        _username = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange[500],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOrder()),
          );
        },
      ),
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                    'Next 7 Days Orders',
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
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('${_username.toLowerCase()}-orders')
          .where('approved', isEqualTo: true)
          .where('date', isGreaterThanOrEqualTo: today)
          .where('date', isLessThanOrEqualTo: seday)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 3.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    final date2 = record.duedate;
    final time2 = record.time;

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 5.0,
              color: record.done == true ? Colors.green
            : Colors.red,
            ),
            bottom: BorderSide(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
        ),
        child: ListTile(
            title: Text(record.name),
            subtitle: Text("$date2   $time2-${record.endtime}"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              var data2 = '$date2${record.name}';
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventPage(title: data2)),
              );
            }),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => record.reference.delete(),
        ),
      ],
    );
  }
}

Future<String> getuname() async {
  final prefs = await SharedPreferences.getInstance();
  final name = "username";
  var user = prefs.getString(name);
  var username = '${user[0].toUpperCase()}${user.substring(1)}';
  print('get $username');
  return username;
}
class Record {
  final String name;
  final String duedate;
  final String time;
  final String endtime;
  final bool done;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['date'] != null),
        assert(map['time'] != null),
        assert(map['endtime'] != null),
        assert(map['done'] != null),
        name = map['name'],
        duedate = map['date'],
        done = map['done'],
        endtime = map['endtime'],
        time = map['time'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$time>";
}
