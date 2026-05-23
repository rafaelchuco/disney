import 'package:disney/app/theme/app_theme.dart';
import 'package:disney/features/landing/presentation/screens/landing_screen.dart';
import 'package:flutter/material.dart';

class DisneyApp extends StatelessWidget {
  const DisneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disney+',
      theme: AppTheme.darkTheme,
      home: const LandingScreen(),
    );
  }
}
