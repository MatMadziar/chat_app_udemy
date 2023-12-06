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
  var _messageController = TextEditingController();

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
  void _submitMessage() {
    // bazw thn eisodo tou xrhsth se metablith kai thn kanw text
    final entredMessage = _messageController.text;

    // tsekarw an den einai adio meta apo trimarisma
    if (entredMessage.trim().isEmpty) {
      return;
    }

    //-------------- send to firebase START --------------

    //-------------- send to firebase END --------------

    // afou stalthei to minima katharizw to pedio tou text na mhn exei to proigoumeno mhnima
    _messageController.clear();
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
