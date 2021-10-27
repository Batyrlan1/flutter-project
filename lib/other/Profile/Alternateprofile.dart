import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlternateProfile with ChangeNotifier {
  Widget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }
}
