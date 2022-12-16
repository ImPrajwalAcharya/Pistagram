import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pistagram/models/post.dart';
import 'package:pistagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';


class FirestoreMethos {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String userName,
    String profImage,
  ) async {
    String res = 'some error occurred';
    try {
      String postId = const Uuid().v1();
      String postUrl = await StorageMethods().uploadimage('posts', file, true);
      Post post = Post(
          description: description,
          uid: uid,
          postId: postId,
          userName: userName,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          profImage: profImage,
          likes: []);
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = 'Posted';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //deleting post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {}
  }

  Future<void> followUser(
    String uid,
    String followuid,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('user').doc(uid).get();

      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followuid)) {
        await _firestore.collection('user').doc(followuid).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followuid])
        });
      } else {
        await _firestore.collection('user').doc(followuid).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followuid])
        });
      }
    } catch (e) {}
  }

  Future<void> message(
    String photourl,
    String username,
    String uid,
  ) async {
    try{
      await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid). collection('messages').doc(uid).set({
          'message':[],
          'photourl':photourl,
          'uesrname':username,
          'messageuid':uid
         });
         DocumentSnapshot snap =
          await _firestore.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
         await FirebaseFirestore.instance.collection('user').doc(uid). collection('messages').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'message':[],
          'photourl':(snap.data()! as dynamic)['photourl'],
          'uesrname':(snap.data()! as dynamic)['username'],
          'messageuid':FirebaseAuth.instance.currentUser!.uid
         });
    }
    catch(e){

    }
  }
}
