import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'components/list.dart';
import 'components/new_entry.dart';
import 'components/photo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  void loadEntries() async {
    int newCount = 0;
    await posts.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newCount++;
        print(doc['title']);
      });
    });
    setState(() {
      _counter = newCount;
    });
  }

  FutureOr goBack(dynamic value) {
    loadEntries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text('${widget.title} - ${_counter}')),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            List(),
            FutureBuilder<DocumentSnapshot>(
              future: posts.doc('MPawh8v6wIaJT1fY7Bgx').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Text("${data['title']} ${data['count']}");
                }

                return Text("loading");
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () =>
            //nav to entry upload

            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const NewEntry();
          }),
        ), //.then(goBack),
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
