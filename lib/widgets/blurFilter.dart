import 'dart:ui';

import 'package:flutter/material.dart';

class BlurFilter extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  BlurFilter({this.child, this.sigmaX = 5.0, this.sigmaY = 5.0});

  @override
  Widget build(BuildContext context) {  
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          top: 4.0,
          right:4,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigmaX,
                sigmaY: sigmaY,
              ),
              child: Opacity(
                opacity: 0.01,
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
