import 'package:flutter/material.dart';

class Snackbar extends StatefulWidget {
  Snackbar({Key key}) : super(key: key);

  @override
  _SnackbarState createState() => new _SnackbarState();
}

class _SnackbarState extends State<Snackbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showInSnackBar("Some text");
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Scaffold(body: new Text("Simple Text")));
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }
}
