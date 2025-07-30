import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:Nikazhthi/Project/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appName = 'Signup';

void main() => runApp(MaterialApp(
      title: appName,
      home: SignupPage(),
    ));

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final myControllerUName = TextEditingController();
  final myControllerBName = TextEditingController();
  final myControllerBLoc = TextEditingController();
  final myControllerPsw = TextEditingController();
  final myControllerMail = TextEditingController();
  final myControllerPsw2 = TextEditingController();
  final myControllerContact = TextEditingController();
  File _image;
  bool _showable = true;
  Future getImg() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

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
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        _image == null
                            ? Text('    No image selected.  ')
                            : Image.file(_image, width: 100, height: 50),
                        RaisedButton(
                            onPressed: () {
                              getImg();
                            },
                            child: Text(
                              'Select',
                            ))
                      ],
                    ),
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
                          return 'Please enter Business Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.business,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          hintStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Business Name'),
                      controller: myControllerBName,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Business Location';
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
                          hintText: 'Business Location'),
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
                  Row(children: <Widget>[
                    Text('    Is Yours Orders are Public?'),
                    CupertinoSwitch(value: _showable, onChanged: (value) {
                    setState(() {
                     _showable = value; 
                     print(_showable);
                    });
                  } ),
                  ],),
                  
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
                        // SnackBar
                        final snackBar = SnackBar(
                            content: Row(
                          children: <Widget>[
                            Text('Signing up... '),
                            Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: CircularProgressIndicator()),
                          ],
                        ));
                        _scaffoldKey.currentState.showSnackBar(snackBar);

                        var alertmsg;
                        QuerySnapshot querySnapshot = await Firestore.instance
                            .collection("users")
                            .where('username',
                                isEqualTo: myControllerUName.text.toLowerCase())
                            .getDocuments();
                        if (myControllerUName.text == '' ||
                            myControllerMail.text == '' ||
                            myControllerBName.text == '' ||
                            myControllerPsw.text == '' ||
                            myControllerPsw2.text == '' ||
                            _image == null) {
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
                          var imgurl =
                              await _pickSaveImage(myControllerUName.text);
                          _save(myControllerUName.text);
                          await Firestore.instance
                              .collection('users')
                              .document()
                              .setData({
                            'username': myControllerUName.text.toLowerCase(),
                            'password': myControllerPsw.text,
                            'email': myControllerMail.text.toLowerCase(),
                            'business': myControllerBName.text,
                            'location': myControllerBLoc.text,
                            'contact': myControllerContact.text,
                            'img': imgurl,
                          });
                          await Firestore.instance
                              .collection(
                                  '${myControllerUName.text.toLowerCase()}-orders')
                              .document()
                              .setData({
                            'name': 'Name',
                            'date': '2019-07-26',
                            'time': '18:00',
                            'endtime': '19:00',
                            'address': 'Some Address',
                            'contact': '0765433212',
                            'done': false,
                            'approved': true,
                          });
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
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

  Future<String> _pickSaveImage(String username) async {
    File imageFile = _image;
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('Images/')
        .child("$username-image.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }
}
