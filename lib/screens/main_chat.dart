import 'package:chatter/provider/message_provider.dart';
import 'package:chatter/screens/splash.dart';
import 'package:chatter/styles/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainChat extends StatefulWidget {
  const MainChat({super.key});

  @override
  State<MainChat> createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.polyGreen,
        foregroundColor: AppStyles.babyPowder,
        title: const Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Splash()));
            },
            icon: Icon(Icons.logout, color: AppStyles.babyPowder),
          ),
        ],
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
                      ListTile(
                        title: Text(message.content),
                        subtitle: Text(message.uid),
                        trailing: Text(message.dateTime.toString()),
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
}
