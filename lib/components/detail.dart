import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastey/home_page.dart';

class Detail extends StatelessWidget {
  final date;

  final quantity;
  final imageURL;
  final latitude;
  final longitude;

  const Detail(
      {Key? key,
      required this.date,
      required this.quantity,
      required this.latitude,
      required this.longitude,
      required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: Center(child: Text('Wastey')),
        ),
        body: Center(
            child: Container(
                child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
              child: Text(date,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 28)),
            ),
            // Image.file(
            //   File(imageFile!.path),
            //   height: 250,
            //   width: double.infinity,
            //   fit: BoxFit.fitWidth,
            // ),
            Image.network(
              imageURL,
              height: 250,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text('Items: ${quantity}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 28)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text('${latitude} ${longitude}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 15)),
            ),
          ],
        ))));
  }
}
