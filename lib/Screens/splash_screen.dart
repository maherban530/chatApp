import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Core/route_path.dart';
import '../Provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // String? get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? "";
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      provider.currentUserId != ''
          ? Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            )
          : Navigator.pushReplacementNamed(
              context,
              AppRoutes.signup,
            );
    });
  }
  // void initState() {
  //   super.initState();
  //   onRefresh(FirebaseAuth.instance.currentUser);
  // }

  // onRefresh(userCred) async {
  //   // var user = FirebaseAuth.instance.currentUser;
  //   // if (user != null || user != '') {
  //   //   Navigator.pushNamed(
  //   //     context,
  //   //     AppRoutes.login,
  //   //   );
  //   // } else {
  //   // setState(() {
  //   user = userCred;
  //   // });

  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    // if (user == null) {
    //   return LogIn();
    //   // Navigator.pushReplacementNamed(
    //   //   context,
    //   //   AppRoutes.signup,
    //   // );
    // } else {
    //   return Home();
    // }

    // Navigator.pushReplacementNamed(
    //   context,
    //   AppRoutes.login,
    // );
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
