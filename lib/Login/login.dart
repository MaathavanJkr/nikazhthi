import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:Nikazhthi/Project/home.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';


const appName = 'Login';

void main() => runApp(MaterialApp(
      title: appName,
      home: LoginPage(),
    ));

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final myControllerUName = TextEditingController();
  final myControllerPsw = TextEditingController();
  
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
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 150.0,
                      )),
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
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Username'),
                      controller: myControllerUName,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
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
                    padding: EdgeInsets.all(12.0),
                    child: RaisedButton(
                      onPressed: () async {
                          final snackBar =
                              SnackBar(content: Row(children: <Widget>[Text('Logging In... '), Padding(padding: EdgeInsets.only(left: 30.0),child: CircularProgressIndicator()),],));
                          _scaffoldKey.currentState.showSnackBar(snackBar);

                        QuerySnapshot querySnapshot = await Firestore.instance
                            .collection("users")
                            .where('username',
                                isEqualTo: myControllerUName.text.toLowerCase())
                            .getDocuments();
                        var alertmsg;
                        if (querySnapshot.documents.isEmpty) {
                          if (myControllerUName.text == '') {
                            alertmsg = "Your Username Field is empty";
                          } else {
                            alertmsg = "Your Username is Incorrect Check and Sign in Again.";
                          }
                        } else {
                          if (myControllerPsw.text == '') {
                            alertmsg = "Your Password Field is Empty.";
                          } else {
                            if (myControllerPsw.text ==
                                querySnapshot.documents[0]['password']) {
                              alertmsg = 'no';
                            } else {
                              alertmsg = "Your Password is Incorrect Check and Sign in Again.";
                            }
                          }
                        
                        }
                        if (alertmsg == 'no') {
                          _save(myControllerUName.text);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
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
                                          _scaffoldKey.currentState.hideCurrentSnackBar();
                                          Navigator.pop(context, 'Discard');
                                        }),
                                  ],
                                );
                              });
                        }
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: Border.all(color: Colors.white, width: 1.5),
                      color: Colors.deepPurpleAccent,
                      child: Text(
                        'Login',
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
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      elevation: 0,
                      padding: EdgeInsets.all(15.0),
                      shape: Border.all(color: Colors.white, width: 1.5),
                      color: Colors.transparent,
                      child: Text(
                        'Create a Account',
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
