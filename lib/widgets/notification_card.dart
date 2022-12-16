import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/widgets/post_card.dart';

class NotificationCard extends StatefulWidget {
  final String userImage;
  final String username;
  final String Date;
  final String postId;
  const NotificationCard({
    super.key,
    required this.userImage,
    required this.username,
    required this.Date, required this.postId,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      child: Row(
        children: [
          CircleAvatar(
            // backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(widget.userImage),
            radius: 16,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.username + '   has Posted a new Post',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.Date)
              ],
            ),
          )
        ],
      ),
    );
  }
}
