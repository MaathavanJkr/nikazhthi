import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Nikazhthi/Project/notdone_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:Nikazhthi/sidedrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'order.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const appName = 'Add Order';

void main() => runApp(MaterialApp(
      title: appName,
      home: AddOrderWD(),
    ));

class AddOrderWD extends StatefulWidget {
  final String title;
  AddOrderWD({Key key, this.title}) : super(key: key);
  @override
  AddOrderWDState createState() => AddOrderWDState();
}

class AddOrderWDState extends State<AddOrderWD> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var platform = MethodChannel('crossingthestreams.io/resourceResolver');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _username = '';
  String _date = '';
  @override
  initState() {
    _date = widget.title;
    getuname().then(updateName);
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
                    'Add Order',
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
                      keyboardType: TextInputType.number,
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
            var odate = _date;
            var otime = DateFormat('kk:mm').format(time);
            var dateu = '$odate $otime:00';
            DateTime dated = DateTime.parse(dateu);
            _scheduleNotification(dated);
            Firestore.instance
                .collection('${_username.toLowerCase()}-orders')
                .document()
                .setData({
              'name': myControllerName.text,
              'contact': myControllerCNo.text,
              'address': myControllerCAd.text,
              'date': _date,
              'time': otime,
              'endtime': DateFormat('kk:mm').format(etime),
              'done': false,
              'approved': true
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
          tooltip: 'Add Order',
          child: Icon(Icons.send),
          backgroundColor: Colors.deepOrange[500],
        ),
      );

  void updateName(String name) {
    setState(() {
      this._username = name;
    });
  }
  
  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> _scheduleNotification(DateTime sdate) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 2));
    var scheduledNotificationDateTime2 =
        sdate.subtract(Duration(days: 1));
    var datest = DateFormat('yyyy-MM-dd').format(sdate);
    var timest = DateFormat('kk:mm').format(sdate);
    var vibrationPattern = Int64List(2);
    vibrationPattern[0] = 1000;
    vibrationPattern[1] = 1000;
    var bigTextStyleInformation = BigTextStyleInformation(
        'You have an Order on $datest at $timest \nBe prepared for your Order',
        htmlFormatBigText: true,
        contentTitle: 'You have a New Order',
        htmlFormatContentTitle: true,
        summaryText: 'Be Prepared',
        htmlFormatSummaryText: true);
    var bigTextStyleInformation2 = BigTextStyleInformation(
        'You have a new Order Tommorow at $timest \n Are You Ready',
        htmlFormatBigText: true,
        contentTitle: 'You have an Order Tommorrow',
        htmlFormatContentTitle: true,
        summaryText: 'Be Prepared',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics2 = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation2,
        icon: 'app_icon',
        sound: 'slow_spring_board',
        largeIcon: 'secondary_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation,
        icon: 'app_icon',
        sound: 'slow_spring_board',
        largeIcon: 'secondary_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    
    var platformChannelSpecifics2 = NotificationDetails(
        androidPlatformChannelSpecifics2, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'You have a New Order',
        'You have an Order on $datest at $timest \nBe prepared for your Order',
        scheduledNotificationDateTime,
        platformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        1,
        'You have a new Order Tomorrow',
        'You have a new Order Tommorow at $timest \nAre you Ready?',
        scheduledNotificationDateTime2,
        platformChannelSpecifics2);
        
  }



  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventPage(title: payload)),
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
