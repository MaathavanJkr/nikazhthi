import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clogin.dart';

const appName = 'Signup';

void main() => runApp(MaterialApp(
      title: appName,
      home: CustSignupPage(),
    ));

class CustSignupPage extends StatefulWidget {
  @override
  CustSignupPageState createState() => CustSignupPageState();
}

class CustSignupPageState extends State<CustSignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final myControllerUName = TextEditingController();
  final myControllerFName = TextEditingController();
  final myControllerBLoc = TextEditingController();
  final myControllerPsw = TextEditingController();
  final myControllerMail = TextEditingController();
  final myControllerPsw2 = TextEditingController();
  final myControllerContact = TextEditingController();
  final myControllerContact2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myControllerUName.dispose();
    myControllerPsw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
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
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
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
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Username'),
                      controller: myControllerUName,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Full Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Full Name'),
                      controller: myControllerFName,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Your Location';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.map,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Address'),
                      controller: myControllerBLoc,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Contact Number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Contact Number'),
                      controller: myControllerContact,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Contact Number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Contact Number 2'),
                      controller: myControllerContact2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter E-Mail';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'E-Mail'),
                      controller: myControllerMail,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Password'),
                      controller: myControllerPsw,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Re-Enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Re-Enter Password'),
                      controller: myControllerPsw2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: RaisedButton(
                      onPressed: () async {
                        QuerySnapshot querySnapshot = await Firestore.instance
                            .collection("customers")
                            .where('username',
                                isEqualTo: myControllerUName.text.toLowerCase())
                            .getDocuments();
                        var alertmsg;
                        if (myControllerUName.text == '' ||
                            myControllerMail.text == '' ||
                            myControllerFName.text == '' ||
                            myControllerBLoc.text == '' ||
                            myControllerContact.text == '' ||
                            myControllerContact2.text == '' ||
                            myControllerPsw.text == '' ||
                            myControllerPsw2.text == '') {
                          alertmsg = "All Fields Must be Filled";
                        } else {
                          if (querySnapshot.documents.isNotEmpty &&
                              querySnapshot.documents[0]['username'] ==
                                  myControllerUName.text.toLowerCase()) {
                            alertmsg = "Username Exists. Try Another Username";
                          } else {
                            if (myControllerPsw2.text == myControllerPsw.text) {
                              alertmsg = 'no';
                            } else {
                              alertmsg = "Password doesn\'t Match";
                            }
                          }
                        }
                        if (alertmsg == 'no') {
                          _save(myControllerUName.text);
                          await Firestore.instance
                              .collection('customers')
                              .document()
                              .setData({
                            'username': myControllerUName.text.toLowerCase(),
                            'password': myControllerPsw.text,
                            'email': myControllerMail.text.toLowerCase(),
                            'fullname': myControllerFName.text,
                            'location': myControllerBLoc.text,
                            'contact': myControllerContact.text,
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchList()),
                          );
                        } else {
                          await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("Alert"),
                                  content: Text(alertmsg),
                                  actions: <Widget>[
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
                      elevation: 0,
                      padding: EdgeInsets.all(15.0),
                      shape: Border.all(color: Colors.white, width: 1.5),
                      color: Colors.deepPurpleAccent,
                      child: Text(
                        'Signup',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustLoginPage()),
                        );
                      },
                      elevation: 0,
                      padding: EdgeInsets.all(15.0),
                      shape: Border.all(color: Colors.white, width: 1.5),
                      color: Colors.transparent,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  _save(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final name = "username";
    await prefs.setString(name, username);
    print('saved $username');
  }
}
