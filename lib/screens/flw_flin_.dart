import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListF extends StatefulWidget {
  final title;
  final data;
  const ListF({super.key, this.title, this.data});

  @override
  State<ListF> createState() => _ListFState();
}

class _ListFState extends State<ListF> {
  List<String> list = [];
  void getdata() async {

    for (var i in widget.data[widget.title]) {
      list.add((await FirebaseFirestore.instance.collection('user').doc(i).get() as dynamic)['username']);
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: StreamBuilder<Object>(
          stream:FirebaseFirestore.instance.collection('user').snapshots() ,
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: ((context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(),
                      Text(list[index])
                    ],
                  );
                }));
          }
        ),
      ),
    );
  }
}
