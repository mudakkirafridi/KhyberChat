
import 'package:flutter/material.dart';

void nextScreen(BuildContext context, Widget destination) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}

void nextScreenReplace(BuildContext context, Widget destination) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}

showSnackbar(context ,Color color ,String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: color,duration: const Duration(seconds: 3),)
  );
}