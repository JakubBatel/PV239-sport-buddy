import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  GradientAppBar({
    Widget leading,
    Widget title,
    List<Widget> actions,
    PreferredSizeWidget bottom,
  }) : appBar = AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xFFFF4D00),
                Color(0xFFEE0930),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),
          leading: leading,
          title: title,
          actions: actions,
          bottom: bottom,
        );

  @override
  Size get preferredSize => appBar.preferredSize;

  @override
  Widget build(BuildContext context) => appBar;

}
