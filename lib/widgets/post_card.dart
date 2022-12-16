import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pistagram/models/user.dart';
import 'package:pistagram/provider/userprovider.dart';
import 'package:pistagram/resources/firestore_methods.dart';
import 'package:pistagram/screens/comment_screen.dart';
import 'package:pistagram/screens/profile_screen.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:pistagram/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class postCard extends StatefulWidget {
  final snap;
  const postCard({super.key, required this.snap});

  @override
  State<postCard> createState() => _postCardState();
}

class _postCardState extends State<postCard> {
  bool isLikeAnimating = false;
  int commentslen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    setState(() {
      commentslen = snap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getuser;
    return Container(
      color: MediaQuery.of(context).size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return ProfileScreen(uid: widget.snap['uid']);
                            })));
                          },
                          child: Text(
                            widget.snap['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () async {
                                        FirestoreMethos()
                                            .deletePost(widget.snap['postId']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethos().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: InkWell(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return Dialog(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: InteractiveViewer(
                            maxScale: 4,
                            minScale: 0.5,
                            child: Image.network(
                              widget.snap['postUrl'],
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      );
                    }));
              },
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.scaleDown,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(microseconds: 500),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      child: const Icon(Icons.favorite,
                          color: Colors.white, size: 120),
                      duration: Duration(microseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      isAnimating: isLikeAnimating),
                ),
              ]),
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethos().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(Icons.favorite)
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return CommentsScreen(
                      postId: widget.snap['postId'].toString(),
                    );
                  })));
                },
                icon: Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),
          //Description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length}' ' likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '  ' + widget.snap['description'],
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all ${commentslen} comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
