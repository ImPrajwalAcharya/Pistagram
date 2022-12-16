

import 'package:flutter/material.dart';
import 'package:pistagram/provider/userprovider.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webSccreenLayout;
  final Widget mobileSccreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webSccreenLayout,
      required this.mobileSccreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webSccreenLayout;
      }
      return widget.mobileSccreenLayout;
    });
  }
}
