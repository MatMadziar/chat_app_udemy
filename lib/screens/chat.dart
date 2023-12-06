// we dont need any functionality. statelesswidget is ok
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//
// Se auto to file:
// Rithmizw to activity me to chat. Olh h domh ths selida klp.
// Einai sindedemenh me alla erxeia dart - widget
//

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
      body: const Column(
        children: [
          // to bazw se expanded na mhn exw kapoio error kai na paei katw kato to chat
          Expanded(
            child: ChatMessage(),
          ),
          NewMessage(),
        ],
      ), // ChatMessage(),

      /*const Center(
        child: Text(
          'You are Logged in Bro mou!',
          style: TextStyle(color: Colors.red),
        ),
      ),*/
    );
  }
}
