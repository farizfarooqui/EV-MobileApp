import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallLoader extends StatelessWidget {
  final Color color;
  const SmallLoader({
    super.key,
    this.adaptive = false,
    this.color = Colors.black,
  });
  final bool adaptive;
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            color: color,
          )
        : SizedBox(
            height: 10,
            width: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          );
  }
}
