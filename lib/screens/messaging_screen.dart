import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pistagram/main.dart';
import 'package:pistagram/provider/userprovider.dart';
import 'package:pistagram/screens/feed.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/models/user.dart' as model;
import 'package:pistagram/widgets/messagecard.dart';
import 'package:provider/provider.dart';

class MessageScreeen extends StatefulWidget {
  const MessageScreeen({super.key});

  @override
  State<MessageScreeen> createState() => _MessageScreeenState();
}

class _MessageScreeenState extends State<MessageScreeen> {
  List? following;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getuser;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title:
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
              // IconButton(
              //     onPressed: (() {
              //       Navigator.of(context)
              //           .pushReplacement(MaterialPageRoute(builder: ((context) {
              //         return MyApp();
              //       })));
              //     }),
              //     icon: Icon(Icons.arrow_back)),
              Text('Messaging'),
            // ],
          // ),
          centerTitle: false,
        ),
        body: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .collection('messages')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    // if (user.following.contains(
                    //     (snapshot.data! as dynamic).docs[index]['uid'])) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        radius: 100,
                        hoverColor: Colors.grey,
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return MessageCard(
                              
                              destinationsnap:
                                  (snapshot.data! as dynamic).docs[index],
                              myphoto: user.photoUrl,
                              sourceusername: user.username,
                            );
                          })));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Divider(
                              color: Colors.grey,
                              thickness: 5,
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photourl']),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (snapshot.data! as dynamic).docs[index]
                                    ['uesrname'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
