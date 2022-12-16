import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pistagram/screens/feed.dart';
import 'package:pistagram/screens/notification_screen.dart';
import 'package:pistagram/screens/profile_screen.dart';
import 'package:pistagram/screens/search_screen.dart';

import '../screens/add_post.dart';

const webScreenSize = 600;
final homeScreeenItems = [
   feedScreen(),
          SearchScreen(),
          AddPost(),
          NotificationScreen(),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];
