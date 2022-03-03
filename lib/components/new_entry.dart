import 'package:flutter/material.dart';

class NewEntry extends StatelessWidget {
  const NewEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('New Entry'),
        ),
        body: Center(
            child: Container(
                child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor))));
  }
}
