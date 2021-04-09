import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {

  final Function onPressed;
  final Widget child;

  GradientButton({ this.onPressed, this.child });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.5)
    );

    return Container(
      decoration: ShapeDecoration(
        shape: shape,
        gradient: LinearGradient(
          colors: [Color(0xFFFF4D00), Color(0xFFEE0930)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
        child: child,
        onPressed: onPressed,
      ),
    );
  }

}
