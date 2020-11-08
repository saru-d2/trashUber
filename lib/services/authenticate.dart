import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash_uber/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  //new user based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //anon
  Future signinAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      //on success
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email+pass
  Future signInWithEmail(String email, String passwd) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: passwd);
      FirebaseUser fbuser = result.user;
      return _userFromFirebaseUser(fbuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //reg
  Future regWithEmail(String email, String passwd) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: passwd);
      FirebaseUser fbuser = result.user;
      _db.collection('users').document(fbuser.uid).setData({
        'uid': fbuser.uid,
        'email': email,
      });
      return _userFromFirebaseUser(fbuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async {
    try {
      signOutGoogle();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //gets user
  Future getUser() async {
    try {
      final user = await _auth.currentUser();
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<String> getCurrentUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    final String email = user.email.toString();
    // print(email);
    return email;
  }

  //google sign in
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      if (_googleUser == null) return false;
      final GoogleSignInAuthentication googleAuth =
          await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authresult =
          await _auth.signInWithCredential(credential);
      FirebaseUser user = authresult.user;
      _db.collection('users').document(user.uid).setData({
        'uid': user.uid,
        'email': user.email,
      });
      print(user);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }
}
