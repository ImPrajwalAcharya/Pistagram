import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String userName;
  final  datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.userName,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'username': userName,
        'uid': uid,
        'description': description,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        userName: snapshot['username'],
        uid: snapshot['uid'],
        description: snapshot['description'],
        postId: snapshot['postId'],
        postUrl: snapshot['postUrl'],
        datePublished: snapshot['datePublished'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes']);
  }
}
