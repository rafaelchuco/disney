import 'package:disney/app/router/app_router.dart';
import 'package:disney/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DisneyApp extends StatelessWidget {
  const DisneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Disney+',
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
