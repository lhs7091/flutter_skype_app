import 'dart:io';

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

  // for all user list except of me
  Future<List<SkypeUser>> fetchAllUsers(User currentUser) =>
      _firebaseMethos.fetchAllUsers(currentUser);

  Future<void> addMessageToDb(
          Message message, SkypeUser sender, SkypeUser receiver) =>
      _firebaseMethos.addMessageToDb(message, sender, receiver);

  void uploadImage({
    File image,
    String receiverId,
    String senderId,
    ImageUploadProvider imageUploadProvider,
  }) =>
      _firebaseMethos.uploadImage(
          image, receiverId, senderId, imageUploadProvider);
}
