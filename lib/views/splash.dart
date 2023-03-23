import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void irALogin(context) {
    Navigator.pushNamed(context, '/login');
  }

  void irARegister(context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://images.pexels.com/photos/14642601/pexels-photo-14642601.jpeg"), fit: BoxFit.cover,),
            ),
          ),
          Positioned(
            bottom: 100,
            child: ElevatedButton(onPressed: () => irALogin(context), child: const Text("Iniciar Sesión")),
          ),
          Positioned(
            bottom: 50,
            child: ElevatedButton(onPressed: () => irARegister(context), child: const Text("Register")),
          )
        ],
      ));
  }
}