import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  final double size;
  final String error;
  final Color color;
  const ShowError({
    Key key,
    this.size,
    @required this.error,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          child: Column(
            children: [
              Icon(
                Icons.error,
                size: size,
              ),
              Text(
                "$error",
                style: TextStyle(
                  color: color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
