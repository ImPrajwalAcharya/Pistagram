import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pistagram/resources/storage_methods.dart';
import 'package:pistagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _storage = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    final snap = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some Error occurred';
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty ||
          file == null) {
      } else {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final photourl = await StorageMethods().uploadimage(
          'profilepic',
          file,
          false,
        );
        model.User userdata = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          photoUrl: photourl,
          bio: bio,
          followers: [],
          following: [],
        );
        await _storage
            .collection('user')
            .doc(cred.user!.uid)
            .set(userdata.toJson());

        res = 'Success✅';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'weak password';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some Error occurred';
    try {
      if (email.isEmpty || password.isEmpty) {
        res = 'Please enter all the fields';
      } else {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success✅';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
