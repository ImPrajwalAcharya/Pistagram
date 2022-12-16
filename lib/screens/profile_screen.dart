import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pistagram/resources/firestore_methods.dart';
import 'package:pistagram/screens/flw_flin_.dart';
import 'package:pistagram/screens/messaging_screen.dart';
import 'package:pistagram/utils/colors.dart';
import '../widgets/follow_button.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postlen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isloading = false;
  bool ishovering = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async {
    setState(() {
      isloading = true;
    });
    try {
      final usersnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();
      setState(() {
        userdata = usersnap.data()!;
      });

      //getpostlen
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userdata['uid'])
          .get();
      postlen = postsnap.docs.length;
      isFollowing = userdata['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      followers = userdata['followers'].length;
      following = userdata['following'].length;
      setState(() {
        isloading = false;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(userdata['username']),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            barrierColor: Color.fromARGB(82, 112, 109, 109),
                            barrierDismissible: true,
                            useSafeArea: true,
                            context: context,
                            builder: ((context) {
                              return Dialog(
                                backgroundColor: Colors.grey,
                                clipBehavior: Clip.hardEdge,
                                alignment: Alignment.center,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  //  padding: EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),
                                  child: ListView(
                                    itemExtent: 40,
                                    shrinkWrap: true,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                            hoverColor: mobileBackgroundColor,
                                            onTap: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();

                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Log Out from ' +
                                                  userdata['username'],
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                            hoverColor: mobileBackgroundColor,
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }));
                      },
                      icon: Icon(Icons.more_horiz))
                ],
              ),
              backgroundColor: mobileBackgroundColor,
            ),
            body: SizedBox(
              width: double.infinity,
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userdata['photourl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postlen, 'Posts'),
                                    InkWell(
                                      child: buildStateColumn(
                                          followers, 'Followers'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return ListF(
                                              title: 'followers',
                                              data: userdata,
                                            );
                                          },
                                        ));
                                      },
                                    ),
                                    InkWell(
                                      child: buildStateColumn(
                                          following, 'Following'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return ListF(
                                              title: 'following',
                                              data: userdata,
                                            );
                                          },
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: Colors.grey,
                                        textColor: primaryColor,
                                        text: 'Edit Profile',
                                        function: (() {}),
                                      )
                                    : isFollowing
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                textColor: Colors.white,
                                                text: 'Message',
                                                function: (() async {
                                                  await FirestoreMethos()
                                                      .message(
                                                          userdata['photourl'],
                                                          userdata['username'],
                                                          userdata['uid']);
                                                  Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return MessageScreeen();
                                                    },
                                                  ));
                                                }),
                                              ),
                                              FollowButton(
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                textColor: Colors.black,
                                                text: 'Unfollow',
                                                function: (() async {
                                                  await FirestoreMethos()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userdata['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                }),
                                              ),
                                            ],
                                          )
                                        : FollowButton(
                                            backgroundColor: Colors.blue,
                                            borderColor: Colors.blue,
                                            textColor: Colors.white,
                                            text: 'Follow',
                                            function: (() async {
                                              await FirestoreMethos()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userdata['uid']);
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            }),
                                          )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userdata['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          userdata['bio'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return GridView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: ((context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];
                              return InkWell(
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
                                                      snap: snapshot
                                                          .data!.docs[index]
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
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(snap['postUrl'])),
                              );
                            }));
                      }
                    }))
              ]),
            ),
          );
  }
}

Column buildStateColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        margin: EdgeInsets.only(top: 4, right: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      )
    ],
  );
}
