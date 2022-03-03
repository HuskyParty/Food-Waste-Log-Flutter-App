import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;

  void getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void takeImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

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
                  getImage();
                }),
          ),
          SizedBox(
            width: 150,
            child: RaisedButton(
                child: Text('Take Photo'),
                onPressed: () {
                  takeImage();
                }),
          ),
        ],
      ));
    } else {
      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('New Entry'),
          ),
          body: Center(
              child: Container(
                  child: Column(
            children: [Image.file(File(_imageFile!.path)), Text("yo")],
          ))));
    }
  }
}
