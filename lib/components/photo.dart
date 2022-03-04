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

    setState(() {
      _imageFile = pickedFile;
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return NewEntry(imageFile: pickedFile);
    //   }),
    // ).then(goHome);
  }

  void takeImage(imageUpload) async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return NewEntry(imageFile: pickedFile);
    //   }),
    // ).then(goHome);

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String filePath = '${appDocDir.absolute}/${pickedFile?.path}';

    await uploadFile(pickedFile?.path);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> uploadFile(String? filePath) async {
    File file = File(filePath ?? 'null');

    var num = new Random();

    int newNum = num.nextInt(1000000);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${newNum}')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MyHomePage(title: 'fun');
      }),
    ).then(goHome);
  }

  uploadToDB() async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String filePath = '${appDocDir.absolute}/${_imageFile?.path}';

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return NewEntry(imageFile: _imageFile);
      }),
    ).then(goHome);

    // await uploadFile(filePath);

    // String downloadURL = await firebase_storage.FirebaseStorage.instance
    //     .ref('${appDocDir.absolute}/${_imageFile}')
    //     .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile == null) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: RaisedButton(
                child: Text('Select Photo'),
                onPressed: () async {
                  getImage(_imageFile);
                  uploadToDB();
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
      ));
    } else {
      return Column(
        children: [
          CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ],
      );
      //
    }
  }
}
