import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/splash.dart';
import 'views/login.dart';
import 'views/map.dart';
import 'views/register.dart';
import 'services/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AuthService _auth = AuthService();
  final bool isLogged = await _auth.isLogged();
  runApp(
    MaterialApp(
      initialRoute: isLogged ? '/map' : '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/map': (context) => MapScreen(),
        '/register':(context) => RegisterScreen()
      },
    ),
  );
}