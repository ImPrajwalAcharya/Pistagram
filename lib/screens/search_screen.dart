import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pistagram/resources/firestore_methods.dart';
import 'package:pistagram/screens/profile_screen.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:pistagram/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = TextEditingController();
  bool isshowusers = false;
  @override
  void dispose() {
    super.dispose();
    _search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width > webScreenSize
              ? MediaQuery.of(context).size.width * 0.3
              : double.infinity,
          child: TextFormField(
            controller: _search,
            onFieldSubmitted: (value) {
              setState(() {
                isshowusers = true;
              });
            },
            decoration: InputDecoration(labelText: 'Search for a user'),
          ),
        ),
      ),
      body: isshowusers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('username', isGreaterThanOrEqualTo: _search.text)
                  .get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return ProfileScreen(
                                  uid: (snapshot.data! as dynamic).docs[index]
                                      ['uid']);
                            })));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data as dynamic).docs[index]
                                        ['photourl'])),
                            title: Text(
                              (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                            ),
                          ),
                        );
                      }));
                }
              }),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return MasonryGridView.count(
                    mainAxisSpacing: 3 ,
                    crossAxisSpacing: 3,
                    crossAxisCount:
                        MediaQuery.of(context).size.width > webScreenSize
                            ? 5
                            : 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => InkWell(
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
                      child: Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                      ),
                    ),
                  );
                }
              })),
    );
  }
}
