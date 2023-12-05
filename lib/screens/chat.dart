// we dont need any functionality. statelesswidget is ok
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        // bazw to logout button sto app bar gia LOGOUT
        actions: [
          IconButton(
              onPressed: () {
                // borw na to kanw me dhlwsh metabliths firebase gia logout opos sto auth.dart - "_firebase"
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      // center widget is a place holder widget
      body: const Center(
        child: Text(
          'You are Logged in Bro mou!',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
