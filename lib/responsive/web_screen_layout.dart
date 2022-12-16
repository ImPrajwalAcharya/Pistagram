import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';

class webSccreenLayout extends StatefulWidget {
  const webSccreenLayout({super.key});

  @override
  State<webSccreenLayout> createState() => _webSccreenLayoutState();
}

class _webSccreenLayoutState extends State<webSccreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  // void getUsername() async {
  //   final snap = await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     username = (snap.data() as Map<String,dynamic>)['username'];
  //   });
  // }
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_pistagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigationTapped(0);
              },
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {navigationTapped(1);},
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {navigationTapped(2);},
              icon: Icon(
                Icons.photo,
                color: _page == 2 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {navigationTapped(3);},
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {navigationTapped(4);},
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              )),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: homeScreeenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
