import 'package:chat_app/Core/route_path.dart';
import 'package:chat_app/Screens/Auth_Screen/login.dart';
import 'package:chat_app/Screens/Auth_Screen/otp_screen.dart';
import 'package:chat_app/Screens/Auth_Screen/phone_login.dart';
import 'package:chat_app/Screens/Auth_Screen/signup.dart';
import 'package:chat_app/Screens/Auth_Screen/user_info_get.dart';
import 'package:chat_app/Screens/Dashboard/chat.dart';
import 'package:chat_app/Screens/Dashboard/home.dart';
import 'package:chat_app/Screens/Dashboard/profile.dart';
import 'package:chat_app/Screens/Dashboard/setting.dart';
import 'package:chat_app/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> route =
    <String, WidgetBuilder>{
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.phonelogin: (context) => const PhoneLoginScreen(),
  AppRoutes.otpscreen: (context) => const OTPScreen(),
  AppRoutes.userinfoget: (context) => const UserInformationGet(),
  AppRoutes.signup: (context) => const SignUp(),
  AppRoutes.login: (context) => const LogIn(),
  AppRoutes.home: (context) => const Home(),
  AppRoutes.chat: (context) => const Chat(),
  AppRoutes.setting: (context) => const Setting(),
  AppRoutes.profile: (context) => const Profile(),
};
