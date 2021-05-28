import 'package:flutter/material.dart';

class ProfileCircleAvatar extends StatelessWidget {
  final String pictureUrl;
  final double radius;

  ProfileCircleAvatar({this.pictureUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    if (pictureUrl == null || pictureUrl == '') {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.perm_identity_outlined, size: radius),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(pictureUrl),
    );
  }
}
