import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  final String? uid;
  final String? code;
  FirebaseUser({this.uid, this.code});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }


  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<bool> isLogged() async {
    try {
      final User user = _auth.currentUser!;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  Future loginEmailPassword(String _email, String _password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.toString(),
              password: _password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }


  Future registerEmailPassword(String _email, String _password, String _name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.toString(), password: _password.toString());
      User? user = userCredential.user;
      user?.updateDisplayName(_name);
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}