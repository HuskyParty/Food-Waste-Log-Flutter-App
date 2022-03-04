import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastey/home_page.dart';

class NewEntry extends StatelessWidget {
  final PickedFile? imageFile;

  const NewEntry({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyHomePage(title: 'Wastey');
                  }),
                );
              },
            ),
            backgroundColor: Theme.of(context).accentColor,
            title: Text('New Entry'),
          ),
          body: Center(
              child: Container(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))));
    } else {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyHomePage(title: 'Wastey');
                  }),
                );
              },
            ),
            backgroundColor: Theme.of(context).accentColor,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Center(child: Text('New Post')),
          ),
          body: Center(
              child: Container(
                  child: Column(
            children: [
              Image.file(
                File(imageFile!.path),
                height: 250,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Text("yo")
            ],
          ))));
    }
  }
}
