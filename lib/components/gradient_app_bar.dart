import 'package:flutter/material.dart';

class GradientAppBar extends AppBar {

  GradientAppBar({title}): super(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF4D00), Color(0xFFEE0930)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
      ),
      title: title);

}
