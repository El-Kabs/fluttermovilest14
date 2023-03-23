import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with InputValidationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cellphoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _auth = AuthService();

  void registerEmailPassword(String _email, String _password, String _name) async {
    dynamic register = await _auth.registerEmailPassword(_email, _password, _name);
    if(register.uid == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(register.code)),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro exitoso")),
      );
      Navigator.pushNamed(context, '/login');
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      registerEmailPassword(_emailController.text, _passwordController.text, _nameController.text);
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
                        decoration: InputDecoration(hintText: "Nombre"),
                        controller: _nameController,
                        maxLength: 50,
                        validator: (name) {
                          if (isNameValid(name!))
                            return null;
                          else
                            return 'El nombre es inválido';
                        }),
                    TextFormField(
                        decoration: InputDecoration(
                            hintText: "Email", labelText: "Email"),
                        controller: _emailController,
                        maxLength: 150,
                        validator: (email) {
                          if (isEmailValid(email!))
                            return null;
                          else
                            return 'El correo es inválido';
                        }),
                    TextFormField(
                        decoration: InputDecoration(hintText: "Celular"),
                        controller: _cellphoneController,
                        maxLength: 10,
                        validator: (phone) {
                          if (isPhoneValid(phone!))
                            return null;
                          else
                            return 'El celular es inválido';
                        }),
                    TextFormField(
                        decoration: InputDecoration(hintText: "Password"),
                        controller: _passwordController,
                        maxLength: 25,
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
                          child: const Text("Register")),
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
    return RegExp(r"^\d{10}$").hasMatch(phone) && phone.length == 10;
  }
}
