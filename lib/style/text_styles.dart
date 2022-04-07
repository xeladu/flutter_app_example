import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle heading =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle subHeading =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle reminderSkipped =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade300);
  static TextStyle reminderDone =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade300);
}
