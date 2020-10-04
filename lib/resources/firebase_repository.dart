import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_skype_app/export_path.dart';

class FirebaseRepository {
  FirebaseMethos _firebaseMethos = FirebaseMethos();

  // for getting current user info
  Future<User> getCurrentUser() => _firebaseMethos.getCurrentUser();

  // call login function by google oAuth
  Future<User> signIn() => _firebaseMethos.signIn();

  // call authenticated user by google and return bool type
  Future<bool> authenticateUser(User user) =>
      _firebaseMethos.authenticateUser(user);

  // if new user, regist of new user in DB(firebase firestore)
  Future<void> addDataToDb(User user) => _firebaseMethos.addDataToDb(user);

  // for sign out
  Future<void> signOut() => _firebaseMethos.signOut();
}
