import 'package:flutter/material.dart';

class GradientAppBar extends AppBar {

  GradientAppBar({
    Widget leading,
    Widget title,
    List<Widget> actions,
    PreferredSizeWidget bottom
  }): super(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF4D00), Color(0xFFEE0930)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
      ),
      leading: leading,
      title: title,
      actions: actions,
      bottom: bottom,
  );

}
