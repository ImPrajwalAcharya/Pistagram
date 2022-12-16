import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  const FollowButton(
      {super.key,
      this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 28),
      child: TextButton(
          onPressed:
            function,
        
          child: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            width: 250,
            height: 27,
          )),
    );
  }
}
