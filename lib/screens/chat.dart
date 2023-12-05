// we dont need any functionality. statelesswidget is ok
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
      ),
      // center widget is a place holder widget
      body: Center(child: Text('Logged in!')),
    );
  }
}
