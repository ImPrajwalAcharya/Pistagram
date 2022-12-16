import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadimage(
      String childname, Uint8List file, bool ispost) async {
    Reference ref =
        _storage.ref().child(childname).child(_auth.currentUser!.uid);
    if (ispost) {
      String id = const Uuid().v1();
      ref=ref.child(id);
    }
    UploadTask uploadtask = ref.putData(file);
    TaskSnapshot snap = await uploadtask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
