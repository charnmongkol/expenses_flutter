import 'dart:io'; //to find out which platform is running

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {
  // const AdaptiveTextButton({Key? key}) : super(key: key);
  final String text;
  final Function handler;

  AdaptiveTextButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler(),
          )
        : TextButton(
            child: Text(text),
            style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: handler(),
          );
  }
}
