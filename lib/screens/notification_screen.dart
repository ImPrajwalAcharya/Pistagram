import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:pistagram/widgets/notification_card.dart';

import '../widgets/post_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Notifications'),
        backgroundColor:   MediaQuery.of(context).size.width > webScreenSize? webBackgroundColor: mobileBackgroundColor,
        centerTitle:   MediaQuery.of(context).size.width > webScreenSize?true:false,
      ),
      // body: NotificationCard( userImage: 'https://scontent.fbwa3-1.fna.fbcdn.net/v/t39.30808-6/313030475_149988421087915_8599379951005434958_n.jpg?stp=dst-jpg_s960x960&_nc_cat=1&ccb=1-7&_nc_sid=8bfeb9&_nc_ohc=093aUiIYb-kAX-5QZuU&_nc_ht=scontent.fbwa3-1.fna&oh=00_AT_lFYKPWUO7dyvlm7fOsqG8jVOMe7Pq3cZs5gy9LZ_I9A&oe=635E06D9',
      // username: 'myname',),
      body: Container(
        color: MediaQuery.of(context).size.width > webScreenSize? webBackgroundColor: mobileBackgroundColor,
        width: MediaQuery.of(context).size.width>webScreenSize?MediaQuery.of(context).size.width*0.3:double.infinity,
         margin: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > webScreenSize
                              ? MediaQuery.of(context).size.width * 0.3
                              : 0),
        alignment: Alignment.center,
        child: StreamBuilder(
          
          stream: FirebaseFirestore.instance
              .collection('posts')
             .orderBy('datePublished',descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              // return Container();
              return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder:((context, index) {
                  return  InkWell(
                    onTap: () {
                        showDialog(
                            useRootNavigator: true,
                            barrierColor: mobileBackgroundColor,
                            useSafeArea: true,
                            context: context,
                            builder: ((context) {
                              return Dialog(
                                alignment: Alignment.center,
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: postCard(
                                            snap: snapshot.data!.docs[index]
                                                .data())),
                                    Container(
                                      color: mobileBackgroundColor,
                                      width: double.infinity,
                                      child: IconButton(
                                        
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }));
                      },
                    child: NotificationCard(
                      userImage:
                       (snapshot.data! as dynamic).docs[index]['profImage'],
                      username:
                       (snapshot.data! as dynamic).docs[index]['username'],
                       Date:  DateFormat.yMMMd().format(
                         ( (snapshot.data! as dynamic).docs[index]['datePublished']).toDate(),
                        ).toString(),
                      postId:(snapshot.data! as dynamic).docs[index]['postId'], 
                       ),
                  );
                }),
                
              );
            }
          },
        ),
      ),
    );
  }
}
