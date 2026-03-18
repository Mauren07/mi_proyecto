import 'package:flutter/material.dart';

import 'theme/theme_app.dart';
import 'pages/splash/splash_app.dart';
import 'pages/auth/login.dart';
import 'pages/home/home.dart';
import 'pages/user/form.dart';
import 'pages/user_status/user_status_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeApp.lightTheme,

      initialRoute: '/',

      routes: {

        '/': (context) => const SplashApp(),

        '/login': (context) => const LoginPage(),

        '/home': (context) => const HomePage(),

        '/form': (context) => const UserFormPage(),

        '/user-statuses': (context) => const UserStatusPage(),

      },

    );
  }
}
