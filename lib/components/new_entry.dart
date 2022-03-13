import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastey/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/post_entry.dart';

class NewEntry extends StatelessWidget {
  final String? imageFile;
  final File imageLocal;
  final String? latitude;
  final String? longitude;

  NewEntry(
      {Key? key,
      required this.imageFile,
      required this.imageLocal,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  final formKey = GlobalKey<FormState>();
  final count = TextEditingController();
  final postValues = PostDTO();

  String? savedCount;

  Future<void> addPost(url) {
    DateTime date = DateTime.now();

    postValues.postDate = DateFormat.MMMMEEEEd().format(date).toString();
    postValues.latitude = latitude;
    postValues.longitude = longitude;
    postValues.imageFile = url;

    // Call the user's CollectionReference to add a new user
    return posts
        .add({
          'quantity': postValues.savedCount,
          'date': postValues.postDate,
          'imageURL': postValues.imageFile,
          'longitude': postValues.longitude,
          'latitude': postValues.latitude
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

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
            title: Text('New Post'),
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
                  //imageFile ?? 'https://source.unsplash.com/random/?husky',
                  imageLocal,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fitWidth),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    //
                    //Count
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: TextFormField(
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (text) {
                          postValues.savedCount = text;
                        },
                      ),
                    ),

                    // Add TextFormFields and ElevatedButton here.
                  ],
                ),
              ),
              SizedBox(
                  width: 200,
                  height: 65,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Semantics(
                      label: 'upload button',
                      child: IconButton(
                          icon: Icon(
                            Icons.cloud_upload_rounded,
                            size: 48,
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () async {
                            if (postValues.savedCount == null) {
                              final snackBar = SnackBar(
                                content:
                                    const Text('Please Enter # Items Wasted'),
                                backgroundColor: (Colors.black12),
                                action: SnackBarAction(
                                  label: 'dismiss',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              addPost(imageFile);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return MyHomePage(title: 'Wastey');
                                }),
                              );
                            }
                          }),
                    ),
                  )),
            ],
          ))));
    }
  }
}
