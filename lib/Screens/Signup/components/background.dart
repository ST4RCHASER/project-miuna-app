import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10.0),
      // Here i can use size.width but use double.infinity because both work as a same
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            child,
          ],
        ),
      ),
    );
  }
}
