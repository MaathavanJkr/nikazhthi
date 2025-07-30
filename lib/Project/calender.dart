import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Nikazhthi/sidedrawer.dart';
import 'order.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'add_orderwd.dart';
// Example holidays

void main() {
  initializeDateFormatting().then((_) => runApp(CalendarPage()));
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Orders',
        home: Container(
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
                Colors.deepPurple,
                Colors.purple,
                const Color(0xffA000A0),
              ],
            ),
          ),
          child: Center(
            child: CalendarSPage(
              title: 'Calendar',
            ),
          ),
        ),
        theme: ThemeData(
          // Define the default Brightness and Colors
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurpleAccent,
          accentColor: Colors.purple,

          // Define the default Font Family
          fontFamily: 'Montserrat',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ));
  }
}

class CalendarSPage extends StatefulWidget {
  CalendarSPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarSPageState createState() => _CalendarSPageState();
}

class _CalendarSPageState extends State<CalendarSPage>
    with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events = {};
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;
  String _username = '';
  DateTime _today;
  Map<DateTime, List> _holidays;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _getuname().then((value) {
      setState(() {
        _username = value;
      });
      getlist().then((value) {
        setState(() {
          _events = value;
        });
        getrlist().then((value) {
          setState(() {
            _holidays = value;
          });
          _selectedDay = DateTime.now();
          _today =
              DateTime.parse(DateFormat('yyyy-MM-dd').format(_selectedDay));
          _selectedEvents = _events[_today] ?? [];
          _visibleEvents = _events;
          _visibleHolidays = _holidays;
          _controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 400),
          );

          _controller.forward();
        });
      });
    });

    super.initState();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getrlist(),
      builder: (context, _events) {
        if (_events.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: SideDrawer(),
            floatingActionButton: FloatingActionButton(
              // When the user presses the button, show an alert dialog with the
              // text the user has typed into our text field.
              onPressed: () {
                if (_selectedEvents?.isEmpty ?? true) {
                  String day = DateFormat('yyyy-MM-dd').format(_selectedDay);
                  String data = '$day';
                  print(data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOrderWD(title: data)),
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("Alert"),
                          content: Text(
                              "There is an Order In that Day. \nOrder/s : ${_selectedEvents.toString()}"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                                child: const Text('I\'m Sure'),
                                onPressed: () {
                                  String day = DateFormat('yyyy-MM-dd')
                                      .format(_selectedDay);
                                  String data = '$day';
                                  print(data);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddOrderWD(title: data)),
                                  );
                                }),
                            CupertinoDialogAction(
                                child: const Text('Discard'),
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Discard');
                                }),
                          ],
                        );
                      });
                }
              },
              backgroundColor: Colors.orange[800],
              tooltip: 'Request Order',
              child: Icon(Icons.add),
            ),
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
                        'Calendar',
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Switch out 2 lines below to play with TableCalendar's settings
                    //-----------------------
                    _buildTableCalendar(),
                    // _buildTableCalendarWithBuilders(),
                    const SizedBox(height: 8.0),
                    Expanded(child: _buildEventList()),
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
                        'Calendar',
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
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'en_US',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.twoWeeks: '2 Weeks',
        CalendarFormat.week: 'Week',
      },
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(color: Colors.white),
        weekendStyle: TextStyle().copyWith(color: Colors.red[200]),
      ),
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[500],
        todayColor: Colors.deepOrange[300],
        markersColor: Colors.green,
        weekendStyle: TextStyle().copyWith(color: Colors.red[200]),
        outsideStyle: TextStyle().copyWith(color: Colors.white54),
      ),
      headerStyle: HeaderStyle(
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () {
                    var dateu = DateFormat('yyyy-MM-dd').format(_selectedDay);
                    var data2 = '$dateu$event';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(title: data2)),
                    );
                  },
                ),
              ))
          .toList(),
    );
  }

  Future<String> _getuname() async {
    final prefs = await SharedPreferences.getInstance();
    final name = "username";
    var user = prefs.getString(name);
    var username = '${user[0].toUpperCase()}${user.substring(1)}';
    print('get $username');
    return username;
  }
  gett() {
    getlist();
    getrlist();
  }
  Future<Map<DateTime, List>> getrlist() async {
    var querySnapshot = await Firestore.instance
        .collection("${_username.toLowerCase()}-orders")
        .where('approved', isEqualTo: false)
        .getDocuments();
    var items = querySnapshot.documents;
    var grouped = groupBy(items, (item) => item['date']);
    var map = grouped.map((date, item) => MapEntry(DateTime.parse(date),
        List.generate(item.length, (int index) => item[index]['name'])));
    return map;
  }

  Future<Map<DateTime, List>> getlist() async {
    var querySnapshot = await Firestore.instance
        .collection("${_username.toLowerCase()}-orders")
        .where('approved', isEqualTo: true)
        .getDocuments();
    var items = querySnapshot.documents;
    var grouped = groupBy(items, (item) => item['date']);
    var map = grouped.map((date, item) => MapEntry(DateTime.parse(date),
        List.generate(item.length, (int index) => item[index]['name'])));
    return map;
  }
}
