import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String content;
  final String uid;
  final DateTime dateTime;

  Message({required this.content, required this.uid, required this.dateTime});

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      content: data?['content'] ?? "",
      uid: data?['uid'] ?? "",
      dateTime: DateTime.fromMillisecondsSinceEpoch(data?['dateTime'] ?? 0),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "content": content,
      "uid": uid,
      "dateTime": dateTime.millisecondsSinceEpoch
    };
  }

}