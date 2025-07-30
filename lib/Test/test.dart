import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  uploadImg() {
    FirebaseStorage.instance
        .ref()
        .child('Images/')
        .child('maathavan-image')
        .putFile(_image);

    print('success');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: _image == null
              ? Text('No image selected.')
              : Column(
                  children: <Widget>[
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/new-db-6c77a.appspot.com/o/Images%2Fmaathavan-image?alt=media&token=55f58d74-f397-4e23-87c4-efaadd0a7eb3',
                    ),
                    RaisedButton(
                        onPressed: () {
                          uploadImg();
                        },
                        child: Text(
                          'Upload',
                        ))
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
