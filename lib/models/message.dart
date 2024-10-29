import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message implements Comparable<Message> {
  final String content;
  final String uid;
  final String author;
  final DateTime dateTime;

  bool get isMine => uid == FirebaseAuth.instance.currentUser?.uid;

  Message({
    required this.content,
    required this.uid,
    required this.author,
    required this.dateTime,
  });

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      content: data?['content'] ?? "",
      uid: data?['uid'] ?? "",
      author: data?['author'] ?? "Anònim",
      dateTime: DateTime.fromMillisecondsSinceEpoch(data?['dateTime'] ?? 0),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "content": content,
      "uid": uid,
      "author": author,
      "dateTime": dateTime.millisecondsSinceEpoch
    };
  }

  @override
  int compareTo(Message other) {
    return dateTime.compareTo(other.dateTime);
  }
}
