import 'package:todoapp/home.dart';
import 'package:todoapp/welcomeScreen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final GlobalKey<NavigatorState> aaaaNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    print("Inicalizou");
    navegar();
  }

  void navegar() {
    Future.delayed(Duration(seconds: 3), () {
      aaaaNavigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Titulo da janela",
      color: Colors.black,
      navigatorKey: aaaaNavigatorKey,

      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(color: Colors.white, height: 100, width: 100),
              // Container(height: 20),
              // Container(color: Colors.blue, height: 100, width: 100),
              // FlutterLogo(size: 150),
              Image.asset("assets/images/logo.png", width: 150, height: 150),
              Container(height: 20),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}