import 'package:flutter/material.dart';
import 'package:movielog/screens/signup_screen.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const MovieLogApp());
}

class MovieLogApp extends StatelessWidget {
  const MovieLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieLog',
      theme: AppTheme.light,
      home: const SignUpScreen(),
    );
  }
}
