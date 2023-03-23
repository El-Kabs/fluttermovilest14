import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  void loginEmailPassword(String _email, String _password) async {
    dynamic register = await _auth.loginEmailPassword(_email, _password);
    if(register.uid == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(register.code)),
      );
    }
    else{
      dynamic userData = await _auth.getUser();
      Navigator.pushNamed(context, '/map');
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      loginEmailPassword(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 125, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Image.network(
                "https://www.kadencewp.com/wp-content/uploads/2020/10/alogo-2.png"),
            Padding(
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  children: [
                    TextFormField(
                        decoration: InputDecoration(
                            hintText: "Email", labelText: "Email"),
                        controller: _emailController,
                        validator: (email) {
                          if (isEmailValid(email!))
                            return null;
                          else
                            return 'El correo es inválido';
                        }),
                    TextFormField(
                        decoration: InputDecoration(hintText: "Password"),
                        controller: _passwordController,
                        validator: (password) {
                          if (isPasswordValid(password!))
                            return null;
                          else
                            return 'El password no cumple con la política de seguridad';
                        },
                        obscureText: true),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: ElevatedButton(
                          onPressed: () => submitForm(),
                          child: const Text("Sign In")),
                    )
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) {
    return password.length >= 8 && password.length <= 25;
  }

  bool isEmailValid(String email) {
    return RegExp(
                r"^(?=.{1,64}@.{1,255}$)(?=[^@]{1,64}@[^@]{1,255}$)^([a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+\.)*[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@(([a-zA-Z0-9]+|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.)+[a-zA-Z]{2,}$")
            .hasMatch(email) &&
        email.length <= 150;
  }

  bool isNameValid(String name) {
    return name.length <= 25;
  }

  bool isPhoneValid(String phone) {
    return RegExp(r"^\d{10}$").hasMatch(phone);
  }
}
