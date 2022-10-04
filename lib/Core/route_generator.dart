import 'package:chat_app/Core/route_path.dart';
import 'package:chat_app/Screens/Auth_Screen/login.dart';
import 'package:chat_app/Screens/Auth_Screen/signup.dart';
import 'package:chat_app/Screens/Dashboard/home.dart';
import 'package:chat_app/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> route =
    <String, WidgetBuilder>{
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.signup: (context) => const SignUp(),
  AppRoutes.login: (context) => const LogIn(),
  AppRoutes.home: (context) => const Home(),
};
