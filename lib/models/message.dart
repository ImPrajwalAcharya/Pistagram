import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sourceuser;
  final String destinationuser;
  final String message;

  const Message({
    required this.sourceuser,
    required this.destinationuser, 
    required this.message, 
  });

  Map<String, dynamic> toJson() => {
        'sourceuser': sourceuser,
        'destinationuser': destinationuser,
        'message': message,
      };
  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Message(
      sourceuser: snapshot['sourceuser'],
      destinationuser: snapshot['destinationuser'],
      message: snapshot['message'],
     
    );
  }
}
