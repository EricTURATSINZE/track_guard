import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:incident_tracker/models/app_alerts.dart';

void showToast(AppAlert alert) {
  Fluttertoast.showToast(
    msg: alert.message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: alert.color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
