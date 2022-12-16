import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:pistagram/models/message.dart';
import 'package:pistagram/utils/colors.dart';

class MessageCard extends StatefulWidget {
  final destinationsnap;
  final sourceusername;
  final myphoto;

  const MessageCard({
    super.key,
    this.destinationsnap,
    this.myphoto,
    this.sourceusername,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final TextEditingController messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('messages');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.destinationsnap['uesrname']),
          backgroundColor: mobileBackgroundColor,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.myphoto),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Write a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (messageController.text != '') {
                      await _firestore
                          .doc(widget.destinationsnap['messageuid'])
                          .update({
                        'message': FieldValue.arrayUnion([
                          {
                            'text': messageController.text,
                            'date': DateTime.now(),
                            'senderuid': FirebaseAuth.instance.currentUser!.uid
                          }
                        ])
                      });
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.destinationsnap['messageuid'])
                          .collection('messages')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'message': FieldValue.arrayUnion([
                          {
                            'text': messageController.text,
                            'date': DateTime.now(),
                            'senderuid': FirebaseAuth.instance.currentUser!.uid
                          }
                        ])
                      });

                      messageController.clear();
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'send',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
            
            child: StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('messages')
                    .doc(widget.destinationsnap['messageuid'])
                    .snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    // padding: EdgeInsets.fromLTRB(
                    //     MediaQuery.of(context).size.width * 0.20, 4, 0, 0),
                    itemCount: (snapshot.data as dynamic)['message'].length,
                    itemBuilder: ((context, index) {
                      return (snapshot.data as dynamic)['message'][index]
                                  ['senderuid'] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container()),
                              Flexible(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromARGB(255, 65, 53, 53),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.7)),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (snapshot.data as dynamic)['message']
                                                [index]['text'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            (snapshot.data as dynamic)['message']
                                                    [index]['date']
                                                .toDate()
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey,
                                                decoration: TextDecoration.underline),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                    
                              ),
                              
                            ],
                          )
                          : Row(
    
                            children: [
                              Flexible(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromARGB(255, 43, 41, 41),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.7)),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (snapshot.data as dynamic)['message']
                                                [index]['text'],
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            DateFormat.yMMMd()
                                                .format(
                                                  (snapshot.data
                                                              as dynamic)['message']
                                                          [index]['date']
                                                      .toDate(),
                                                )
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey,
                                                decoration: TextDecoration.underline),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ),
                               Flexible(
                                flex: 2,
                                child: Container()),
                            ],
                          );
                    }),
                  );
                })));
  }
}
