import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_skype_app/export_path.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethos {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // apllication user class
  SkypeUser skypeUser = SkypeUser();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    // if user is resgistered then length of list > 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    skypeUser = SkypeUser(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: Utils.getUsername(currentUser.email),
    );

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(skypeUser.toMap(skypeUser));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  // call all user list except of me and return
  Future<List<SkypeUser>> fetchAllUsers(User currentUser) async {
    List<SkypeUser> userList = List<SkypeUser>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    querySnapshot.docs.forEach((element) {
      if (element.id != currentUser.uid) {
        userList.add(SkypeUser.fromMap(element.data()));
      }
    });
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, SkypeUser sender, SkypeUser receiver) async {
    var map = message.toMap();

    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }
}
