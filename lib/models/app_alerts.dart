import 'package:flutter/material.dart';
import 'package:incident_tracker/utils/theme.dart';

class AppAlert {
  final String title;
  final String message;
  final Color color;
  final IconData icon;

  AppAlert({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
  });
}

class SuccessAlert extends AppAlert {
  SuccessAlert({required super.message})
      : super(title: "Success", color: Colors.green, icon: Icons.check);
}

class ErrorAlert extends AppAlert {
  ErrorAlert({required super.message})
      : super(
          title: "Oh Snap!",
          color: const Color(0xfff9320d),
          icon: Icons.close,
        );
}

class InfoAlert extends AppAlert {
  InfoAlert({required super.message})
      : super(title: "Info!", color: primaryColor, icon: Icons.info_outline);
}
