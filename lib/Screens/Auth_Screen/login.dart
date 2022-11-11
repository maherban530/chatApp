import 'package:chat_app/Screens/Auth_Screen/facebook_demo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Core/theme.dart';
import '../../Provider/auth_provider.dart';
import '../../Utils/constants.dart';
import '../../Widgets/custom_appbar.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogIn();
}

class _LogIn extends State<LogIn> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          color: applicationTheme.backgroundColor,
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildTitle(applicationTheme),
                        _buildEmailAddress(applicationTheme),
                        _buildPassword(applicationTheme),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onLogInButtonPressed(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                            },
                            child: const Text(ApplicationTexts.logInButtonName),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an Account? ",
                      style: applicationTheme.textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: applicationTheme.textTheme.bodyText2!.copyWith(
                          decoration: TextDecoration.underline,
                          color: applicationTheme.primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.signup,
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    radius: 30,
                    borderRadius: BorderRadius.circular(26),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          applicationTheme.primaryColor.withOpacity(0.09),
                      child: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover),
                    ),
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .googleSignIn(context);
                    },
                  ),
                  InkWell(
                    radius: 30,
                    borderRadius: BorderRadius.circular(26),
                    child: Icon(
                      Icons.facebook_rounded,
                      color: Colors.blue.shade900,
                      size: 58,
                    ),
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .facebookSignIn(context);
                    },
                  ),
                  InkWell(
                    radius: 30,
                    borderRadius: BorderRadius.circular(26),
                    child: Icon(
                      Icons.phone_android_rounded,
                      color: applicationTheme.primaryColor,
                      size: 58,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.phonelogin,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTitle(ThemeData applicationTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        'LogIn',
        textAlign: TextAlign.center,
        style: applicationTheme.textTheme.bodyText1,
      ),
    );
  }

  Widget _buildEmailAddress(ThemeData applicationTheme) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return ApplicationTexts.emailIsEmpty;
        } else if (!regExp.hasMatch(value)) {
          return ApplicationTexts.emailIsEmpty;
        } else {
          return null;
        }
      },
      controller: _emailController,
      style: applicationTheme.textTheme.subtitle1,
      decoration:
          _buildInputDecoration(ApplicationTexts.email, applicationTheme),
    );
  }

  Widget _buildPassword(ThemeData applicationTheme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ApplicationTexts.passwordIsEmpty;
        } else if (value.length < 2) {
          return ApplicationTexts.passwordIsEmpty;
        } else {
          return null;
        }
      },
      style: applicationTheme.textTheme.subtitle1,
      decoration:
          _buildInputDecoration(ApplicationTexts.password, applicationTheme),
    );
  }

  InputDecoration _buildInputDecoration(
      String hint, ThemeData applicationTheme) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ApplicationColors.accentColorLight)),
      hintText: hint,
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
      hintStyle: applicationTheme.textTheme.subtitle1,
      errorStyle: const TextStyle(color: ApplicationColors.errorColor),
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ApplicationColors.errorColor)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ApplicationColors.errorColor)),
    );
  }

  void _onLogInButtonPressed(String email, String password) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    provider.logIn(email, password).then((result) {
      if (result) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
      }
    });
  }
}
