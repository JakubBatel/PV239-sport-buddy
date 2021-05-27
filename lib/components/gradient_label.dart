import 'package:flutter/cupertino.dart';

class GradientLabel extends StatelessWidget {
  final Widget child;

  GradientLabel({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.5),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFFF4D00), Color(0xFFEE0930)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
