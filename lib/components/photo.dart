import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wastey/components/new_entry.dart';
import 'package:wastey/home_page.dart';

class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  bool? _wait = false;
  String? url;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  FutureOr goHome(dynamic value) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MyHomePage(title: 'Wastey');
      }),
    );
  }

  void getImage(imageUpload) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    await uploadFile(pickedFile?.path);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void takeImage(imageUpload) async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _wait = true;
      _imageFile = pickedFile;
    });

    await uploadFile(pickedFile?.path);
  }

  Future<void> uploadFile(String? filePath) async {
    File file = File(filePath ?? 'null');

    var num = new Random();
    int newNum = num.nextInt(1000000);

    String? downloadURL;

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${newNum}')
          .putFile(file);

      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${newNum}')
          .getDownloadURL();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return NewEntry(imageFile: downloadURL, imageLocal: file);
        }),
      ).then(goHome);
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_wait == true) {
      return Scaffold(
          body: Center(
              child: Container(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))));
      //
    } else {
      return Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: RaisedButton(
                child: Text('Select Photo'),
                onPressed: () async {
                  getImage(_imageFile);
                  //uploadToDB();
                }),
          ),
          SizedBox(
            width: 150,
            child: RaisedButton(
                child: Text('Take Photo'),
                onPressed: () async {
                  takeImage(_imageFile);
                  //uploadToDB();
                }),
          ),
        ],
      )));
      //
    }
  }
}
