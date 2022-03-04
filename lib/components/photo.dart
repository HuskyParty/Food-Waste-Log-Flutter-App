import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return NewEntry(imageFile: pickedFile);
      }),
    ).then(goHome);
  }

  void takeImage(imageUpload) async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return NewEntry(imageFile: pickedFile);
      }),
    ).then(goHome);

    setState(() {
      _imageFile = pickedFile;
    });
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
                onPressed: () {
                  getImage(_imageFile);
                }),
          ),
          SizedBox(
            width: 150,
            child: RaisedButton(
                child: Text('Take Photo'),
                onPressed: () {
                  takeImage(_imageFile);
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
