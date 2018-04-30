import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthInstance {
  bool isAuthenticated = false;
  FirebaseUser user;

  Future<int> ensureLoggedIn() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      return 1;
    }
    isAuthenticated = true;
    return 0;
  }

  void authenticate(email, password) async {
    this.user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    isAuthenticated = true;
  }

  void createAccount(email, password) async {
    this.user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    isAuthenticated = true;
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
    isAuthenticated = false;
  }

}