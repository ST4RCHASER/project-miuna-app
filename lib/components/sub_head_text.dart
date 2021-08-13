import 'package:flutter/material.dart';
import 'package:project_miuna/constants.dart';

class SubTextHeader extends StatelessWidget {
  final Widget child;
  const SubTextHeader({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}
