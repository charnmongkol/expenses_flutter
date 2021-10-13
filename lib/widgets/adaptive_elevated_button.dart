import 'dart:io'; //to find out which platform is running

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveElevatedButton extends StatelessWidget {
  // const AdaptiveElevatedButton({Key? key}) : super(key: key);
  final String text;
  final Function handler;

  AdaptiveElevatedButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(text),
            onPressed: handler(),
          )
        : ElevatedButton(
            child: Text(text),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context)
                  .primaryColor, //background color of ElevatedButton
              //onPrimary: Colors.white, //text color of ElevatedButton
              textStyle: Theme.of(context)
                  .textTheme
                  .button, //Text color derived from theme
              onSurface: Colors.redAccent,
            ),
            onPressed: handler());
  }
}
