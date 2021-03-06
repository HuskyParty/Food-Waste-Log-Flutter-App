import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastey/components/detail.dart';
import 'firebase_options.dart';

import 'components/list.dart';
import 'components/new_entry.dart';
import 'components/photo.dart';
import 'components/detail.dart';
import 'dart:convert';

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
  final Stream<QuerySnapshot> _postsStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  void loadEntries() async {
    int newCount = 0;
    await posts.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newCount += int.parse(doc['quantity']);
      });
    });
    setState(() {
      _counter = newCount;
    });
  }

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  FutureOr goBack(dynamic value) {
    loadEntries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings_sharp, color: Theme.of(context).primaryColor),
            Text('  ${widget.title} - ${_counter}',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _postsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return snapshot.data?.size == 0
                ? Center(
                    child: Container(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor)))
                : ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${data['date']} ",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                                Text("${data['quantity']}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                          //subtitle: int(data['count']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Detail(
                                    date: data['date'],
                                    quantity: data['quantity'],
                                    latitude: data['latitude'],
                                    longitude: data['longitude'],
                                    imageURL: data['imageURL']);
                              }),
                            );
                          });
                    }).toList(),
                  );
          }),

      floatingActionButton: Semantics(
        label: 'new post button',
        child: FloatingActionButton(
            foregroundColor: Theme.of(context).primaryColor,
            onPressed: () =>
                //nav to entry upload

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Photo();
                  }),
                ), //.then(goBack),
            tooltip: 'Photo',
            child: Icon(Icons.camera_alt_outlined,
                color: Theme.of(context).primaryColor)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
