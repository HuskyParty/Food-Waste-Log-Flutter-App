import 'package:flutter/material.dart';

class NewEntry extends StatelessWidget {
  const NewEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('New Entry'),
        ),
        body: Center(child: Container(child: Text("yo"))));
  }
}
