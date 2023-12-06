import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//
// Se auto to file:
// Rithmizw to ginete me kathe neo minima pou tha stelenei o xrhsths
//

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  //create
  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  // I need to add this for controller user input
  @override
  void dispose() {
    // in order for memorie recources occupied by the conroller get freed up
    _messageController.dispose();
    super.dispose();
  }

//-------------  START to save and store in FIREBASE ----------------
// I need this function to send user message to firebase
// void doesn not return any value
// edw rithmizw ti kai pws tha stalthei sth bash mou. mesa sae auth th sinarthsh
  void _submitMessage() async {
    // bazw thn eisodo tou xrhsth se metablith kai thn kanw text
    final entredMessage = _messageController.text;

    // tsekarw an den einai adio meta apo trimarisma
    if (entredMessage.trim().isEmpty) {
      return;
    }

    // gia na katebasw to keyboard
    // put ut here because I don't want to keep the keyboard open when I send the data to Firestore
    FocusScope.of(context).unfocus();
    // afou stalthei to minima katharizw to pedio tou text na mhn exei to proigoumeno mhnima
    _messageController.clear();
    //

    //-------------- send messages to firebase START --------------

    // I use also the authentication here for the credential of Current logged IN USER (should not be null)
    // den tha einai pote null gt gia na bei kapoios sto chat activity exei perasei to authentication outos h allios
    final user = FirebaseAuth.instance.currentUser!;
    //
    // me to apo katw fernw ta stoixia apo th bash dedomenon gia na wta steilw meta sth basi mazi me ta messages
    // me to get fernw ta stoixia apo to path pou dialeksa
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //
    // I dont make my own name but I will assign to the doc (add())
    // unique id (automated generated) provided by firebase
    FirebaseFirestore.instance.collection('chat').add({
      'text': entredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      // to use the user name and image We need to retrieve them from firestore
      'userName': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    //-------------- send messages to firebase END --------------
  }

  //-------------  END to save and store in FIREBASE ----------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // I add controlles to enter the value of user input
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            // when I press the button I want to save the user input and send them to firebase
            onPressed: _submitMessage, // stelnw sto firebase
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
