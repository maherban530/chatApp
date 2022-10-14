import 'package:chat_app/Models/user_model.dart';
import 'package:chat_app/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Core/theme.dart';
import '../../Utils/constants.dart';
import '../../Widgets/custom_appbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: applicationTheme.backgroundColor,
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
                        _buildTitle(applicationTheme),
                        _buildFirstName(applicationTheme),
                        _buildPhoneNumber(applicationTheme),
                        _buildEmailAddress(applicationTheme),
                        _buildPassword(applicationTheme),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 30.0),
                          child: SizedBox(
                            height: 60,
                            width: deviceSize.width,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  _onRegisterButtonPressed(
                                    _firstNameController.text,
                                    _phoneController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                              },
                              child: Container(
                                color: ApplicationColors.accentColorLight,
                                alignment: Alignment.center,
                                //  decoration: const BoxDecoration(
                                //     image: DecorationImage(
                                //         image: AssetImage(
                                //             'assets/images/welcome_button_bg.png'),
                                //         fit: BoxFit.fill)),
                                child: Center(
                                  child: Text(
                                    ApplicationTexts.signUpButtonName,
                                    textAlign: TextAlign.center,
                                    style: applicationTheme.textTheme.bodyText1!
                                        .copyWith(
                                            color: ApplicationColors
                                                .backgroundDark),
                                  ),
                                ),
                              ),
                            ),
                            //  ElevatedButton(
                            //   // style: ButtonStyle(
                            //   //     backgroundColor:
                            //   //         MaterialStateProperty.all<Color>(
                            //   //             Colors.transparent)),
                            //   // padding: EdgeInsets.zero,
                            //   child: Center(
                            //     child: Container(
                            //       height: 60,
                            //       width: deviceSize.width,
                            //       alignment: Alignment.center,
                            //       child: Text(ApplicationTexts.LETS_START,
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 20,
                            //               fontFamily: "Maccabi",
                            //               fontWeight: FontWeight.w400)),
                            //       padding:
                            //           EdgeInsets.fromLTRB(28, 10, 30, 20),
                            //       decoration: BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/images/welcome_button_bg.png'),
                            //               fit: BoxFit.fill)),
                            //     ),
                            //   ),
                            //   onPressed: () {
                            //     if (_formKey.currentState.validate()) {
                            //       _onRegisterButtonPressed(
                            //           _firstNameController.text,
                            //           _lastNameController.text,
                            //           _phoneController.text,
                            //           _emailController.text);
                            //     }
                            //   },
                            // ),
                          ),
                        ),
                      ],
                    ),
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    );
                  },
                  child: const Text('LogIn')),
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
        'SignUp',
        textAlign: TextAlign.center,
        style: applicationTheme.textTheme.bodyText1,
      ),
    );
  }

  Widget _buildFirstName(ThemeData applicationTheme) {
    return TextFormField(
      controller: _firstNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return ApplicationTexts.firstNameIsEmpty;
        } else if (value.length < 2) {
          return ApplicationTexts.firstNameIsEmpty;
        } else {
          return null;
        }
      },
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.firstName),
    );
  }

  Widget _buildPhoneNumber(ThemeData applicationTheme) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    RegExp regExp = RegExp(pattern);
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return ApplicationTexts.phoneNumberError;
        } else if (!regExp.hasMatch(value)) {
          return ApplicationTexts.phoneNumberError;
        } else {
          return null;
        }
      },
      controller: _phoneController,
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.phoneNumber),
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
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.email),
    );
  }

  Widget _buildPassword(ThemeData applicationTheme) {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return ApplicationTexts.passwordIsEmpty;
        } else if (value.length < 2) {
          return ApplicationTexts.passwordIsEmpty;
        } else {
          return null;
        }
      },
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.password),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ApplicationColors.accentColorLight)),
      hintText: hint,
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
      hintStyle:
          const TextStyle(color: ApplicationColors.primaryTextColorLight),
      errorStyle: const TextStyle(color: ApplicationColors.errorColor),
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ApplicationColors.errorColor)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))),
    );
  }

  void _onRegisterButtonPressed(
      String firstName, String phone, String email, String password) async {
    Users userModel = Users(
      email: email,
      name: firstName,
      userPic: '',
      phoneNumber: phone,
      userStatus: 'Online',
      fcmToken: '',
      uid: '',
    );

    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.signUp(userModel, password).then((result) {
      if (result) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
      }
    });
  }
}
