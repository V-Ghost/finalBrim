
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';


Widget barIndicator(int value) =>FAProgressBar(
     progressColor : Colors.purple,
      size: 10,
      currentValue: value,
      backgroundColor: Colors.white
      
      // displayText: '%',
    );