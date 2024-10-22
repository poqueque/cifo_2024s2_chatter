import 'package:chatter/screens/main_chat.dart';
import 'package:chatter/styles/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String status = "";
  final providers = [EmailAuthProvider()];

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              size: 100,
              color: AppStyles.forestGreen,
            ),
            Text(status),
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    changeStatus("Inicialitzant aplicació");
    await Future.delayed(const Duration(milliseconds: 500));
    changeStatus("Carregant (25%)");
    await Future.delayed(const Duration(milliseconds: 500));
    changeStatus("Carregant (50%)");
    await Future.delayed(const Duration(milliseconds: 500));
    changeStatus("Carregant (75%)");
    await Future.delayed(const Duration(milliseconds: 500));
    changeStatus("Carregant (100%)");
    if (FirebaseAuth.instance.currentUser == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignInScreen(
                    providers: providers,
                    actions: [
                      AuthStateChangeAction<SignedIn>((context, state) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainChat()));
                      }),
                      AuthStateChangeAction<UserCreated>((context, state) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainChat()));
                      }),
                    ],
                  )));
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainChat()));
    }
  }

  void changeStatus(String st) {
    status = st;
    setState(() {});
  }
}
