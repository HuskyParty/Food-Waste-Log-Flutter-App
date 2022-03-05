import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
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

    await uploadFile(pickedFile?.path);

    setState(() {
      _imageFile = pickedFile;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return NewEntry(imageFile: pickedFile);
      }),
    ).then(goHome);
  }

  Future<void> uploadFile(String? filePath) async {
    File file = File(filePath ?? 'null');

    var num = new Random();
    int newNum = num.nextInt(1000000);
    DateTime date = DateTime.now();
    String postDate = DateFormat.MMMMEEEEd().format(date).toString();
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

      addPost(downloadURL);
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> addPost(url) {
    DateTime date = DateTime.now();

    String postDate = DateFormat.MMMMEEEEd().format(date).toString();
    // Call the user's CollectionReference to add a new user
    return posts
        .add({
          'count': 5,
          'title': 'Test Post',
          'date': postDate,
          'photoPath': url
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add user: $error"));
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
      ));
    } else {
      return Column(
        children: [
          // CircularProgressIndicator(color: Theme.of(context).primaryColor),
          Image.file(
            File(_imageFile!.path),
            height: 250,
            width: double.infinity,
            fit: BoxFit.fitWidth,
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
      );
      //
    }
  }
}
