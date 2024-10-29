import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chatter/extensions/date_extension.dart';
import 'package:chatter/provider/message_provider.dart';
import 'package:chatter/screens/splash.dart';
import 'package:chatter/styles/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MainChat extends StatefulWidget {
  const MainChat({super.key});

  @override
  State<MainChat> createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.polyGreen,
        foregroundColor: AppStyles.babyPowder,
        title: const Text("Chat App"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text(FirebaseAuth.instance.currentUser?.displayName ?? "---"),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser?.email ?? "---"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(FirebaseAuth
                        .instance.currentUser?.photoURL ??
                    "https://static.thenounproject.com/png/5034901-200.png"),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Nom d'usuari"),
              onTap: editUserName,
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Foto de perfil"),
              onTap: changeProfileImage,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Tancar sessió"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Splash()));
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Consumer<MessageProvider>(
            builder: (context, messageProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView(
                  reverse: true,
                  children: [
                    for (var message in messageProvider.messages.reversed)
                      Column(
                        children: [
                          if (!message.isMine)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  message.author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          BubbleSpecialOne(
                            text: message.content,
                            isSender: message.isMine,
                            color: (message.isMine)
                                ? AppStyles.frenchGray
                                : AppStyles.lightGreen,
                          ),
                          Align(
                            alignment: (message.isMine)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                message.dateTime.formatTime(),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  onSubmitted: sendMessage,
                  decoration: InputDecoration(
                      hintText: "Escriu un missatge",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () => sendMessage(controller.text),
                          icon: const Icon(Icons.send))),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void sendMessage(String value) {
    context.read<MessageProvider>().addMessage(value);
    controller.clear();
  }

  void editUserName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nom d'usuari"),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Introdueix un nom d'usuari",
          ),
        ),
        actions: [
          TextButton(
            onPressed: saveUserName,
            child: const Text("GUARDAR"),
          ),
        ],
      ),
    );
  }

  Future<void> saveUserName() async {
    var name = nameController.text;
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    if (!mounted) return;
    Navigator.pop(context);
    setState(() {});
  }

  Future<void> changeProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final userFolderRef =
          storageRef.child(FirebaseAuth.instance.currentUser!.uid);
      final imageRef = userFolderRef.child("profile.png");
      final imageFile = File(image.path);
      await imageRef.putFile(imageFile);
      final downloadUrl = await imageRef.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);
      setState(() {});
    }
  }
}
