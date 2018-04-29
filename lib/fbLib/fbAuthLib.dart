import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

class AuthenticationKey {
  bool isAuthenticated = false;
  var fbUser = null;

  void authenticate(email, password) async {
    this.fbUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  void createAccount(email, password) async {
    this.fbUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }
}