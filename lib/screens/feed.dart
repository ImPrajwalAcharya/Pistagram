import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pistagram/provider/userprovider.dart';
import 'package:pistagram/screens/messaging_screen.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:pistagram/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:pistagram/models/user.dart' as model;

class feedScreen extends StatefulWidget {
  const feedScreen({super.key});

  @override
  State<feedScreen> createState() => _feedScreenState();
}

class _feedScreenState extends State<feedScreen> {
  void navigateToMessaging() {
    Navigator
        .push(context,MaterialPageRoute(builder: ((context)=> 
       MessageScreeen()
    )));
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getuser;
    return Scaffold(
      backgroundColor: MediaQuery.of(context).size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                'assets/ic_pistagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                    onPressed: navigateToMessaging,
                    icon: Icon(Icons.message_sharp))
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return user.following
                      .contains(snapshot.data!.docs[index].data()['uid'])
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width > webScreenSize
                                  ? MediaQuery.of(context).size.width * 0.3
                                  : 0),
                      child: postCard(snap: snapshot.data!.docs[index].data()),
                    )
                  : Container();
            },
          );
        }),
      ),
    );
  }
}
