import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//
// Se auto to file:
// Rithmizw to ginete me ta minimata ths sinomilias olhs
//

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    // we update the screen whenever something new is added to collection
    // chatSnapshot will be the object that give us access to the backend
    final authenicatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          //na emfanizonde se seira me bash thn hmerominia
          // descenging false = to show the latest message in the bottom - otan einai panw ta minimata
          // an to thelw san to fb messeget to kanw true! SOS
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        //------------  elegxw gia pithana errors START ---------------------
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // oso den exw data OR chatShapshot has no documents (is an empty list)
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found...'),
          );
        }
        //
        // Prepei na tsekarw gia daifora errors
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something were wrong'),
          );
        }
        //------------  elegxw gia pithana errors END ---------------------

        // OTAN epibebeosw oti exw dedomena kai h sindesh den exei thema,
        // --------------- Make lisgt with messages START ----------------------
        // Tote ftiaxnw th lista me ta minimata pou exoun stalthei
        final loadedMessages = chatSnapshot.data!.docs;
        //
        return ListView.builder(
          // edw fitaxnw to design ths listas
          padding: EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          // edw fitaxnw to functionality ths listas
          reverse: true, // gia na paei apw katw ts othonis (fb messager)
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            //edw bazw to  bubble widget pou perigrafei thn emfanish twn minimatwn
            // its map contain data
            final chatMessage = loadedMessages[index].data();
            // I need to check the last message is from which user. roznia sie efektem wizualnym
            // if is not smallter than loadmessages its means that the messages doesn't exist
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index].data()
                : null;

            // I use the users ID in order to prevent the issue with the same usernames (ID is unique)
            final currentMessageUserID = chatMessage['userId'];
            // if there is no next message we will put null in the next message username
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            // I check if the message is from the same user
            final nextUserIsSame = nextMessageUserId == currentMessageUserID;

            // if the user is the same return different styling, using message_bubble.dart file
            if (nextUserIsSame) {
              return MessageBubble.next(
                  // tsekarw an einai idios o apostoleas me ton authenticated user kai oxi px to 2o atomo pou milane
                  message: chatMessage['text'],
                  isMe: authenicatedUser.uid == currentMessageUserID);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['userName'],
                  message: chatMessage['text'],
                  isMe: authenicatedUser.uid == currentMessageUserID);
            }
          },
          // gia emfanish kathe minimatos se morfi text
          /*=> Text(
            loadedMessages[index].data()['text'],*/
        );
      },
    );
  }
}
