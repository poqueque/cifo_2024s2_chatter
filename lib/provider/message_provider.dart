import 'package:chatter/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  MessageProvider() {
    loadMessages();
  }

  List<Message> messages = [];

  void loadMessages() {
    var docRef = db.collection('chats').doc('room1').collection('messages');
    docRef.snapshots().listen(
      (event) {
        messages =
            event.docs.map((e) => Message.fromFirestore(e, null)).toList();
        messages.sort();
        notifyListeners();
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );
  }

  Future<void> addMessage(String messageContent) async {
    var message = Message(
      content: messageContent,
      uid: FirebaseAuth.instance.currentUser?.uid ?? "",
      author: FirebaseAuth.instance.currentUser?.displayName ?? "Anònim",
      dateTime: DateTime.now(),
    );

    await db
        .collection('chats')
        .doc('room1')
        .collection('messages')
        .add(message.toFirestore());

    notifyListeners();
  }
}
