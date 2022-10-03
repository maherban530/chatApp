import 'package:flutter/material.dart';

import '../../Widgets/custom_appbar.dart';

class RegistrationForm extends StatefulWidget {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  late ThemeData applicationTheme;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    applicationTheme = Theme.of(context);

    return buildInitialLayout(context);
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInitialLayout(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: applicationTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          color: applicationTheme.backgroundColor,
          child: Column(
            children: [
              CustomToolbar(
                  isDrawerVisible: false, onDrawerButtonPressed: () {}),
              Form(
                  key: _formKey,
                  child: Container(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                      child: Column(
                        children: [
                          _buildTitle(),
                          _buildFirstName(),
                          _buildLastName(),
                          _buildPhoneNumber(),
                          _buildEmailAddress(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 30.0),
                            child: SizedBox(
                              height: 60,
                              width: deviceSize.width,
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    _onRegisterButtonPressed(
                                        _firstNameController.text,
                                        _lastNameController.text,
                                        _phoneController.text,
                                        _emailController.text);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(ApplicationTexts.LETS_START,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            // backgroundColor: Colors.red,
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: "Maccabi",
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/welcome_button_bg.png'),
                                          fit: BoxFit.fill)),
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
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        "הירשמו כדי להתחיל. הפרטים שמורים ולא יועברו לאף גורם.",
        textAlign: TextAlign.center,
        style: applicationTheme.textTheme.bodyText1,
      ),
    );
  }

  Widget _buildFirstName() {
    return TextFormField(
      controller: _firstNameController,
      textDirection: TextDirection.rtl,
      validator: (value) {
        if (value.isEmpty) {
          return ApplicationTexts.FIRST_NAME_EMPTY;
        } else if (value.length < 2) {
          return ApplicationTexts.FIRST_NAME_EMPTY;
        } else {
          return null;
        }
      },
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.FIRST_NAME),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      controller: _lastNameController,
      validator: (value) {
        if (value.isEmpty) {
          return ApplicationTexts.LAST_NAME_EMPTY;
        } else if (value.length < 2) {
          return ApplicationTexts.LAST_NAME_EMPTY;
        } else {
          return null;
        }
      },
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.LAST_NAME),
    );
  }

  Widget _buildPhoneNumber() {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
      validator: (value) {
        if (value.isEmpty || !widget.numericRegex.hasMatch(value)) {
          return ApplicationTexts.PHONE_ERROR;
        } else if (!regExp.hasMatch(value)) {
          return ApplicationTexts.PHONE_ERROR;
        } else {
          return null;
        }
      },
      controller: _phoneController,
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.PHONE),
    );
  }

  Widget _buildEmailAddress() {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return ApplicationTexts.EMAIL_EMPTY;
        } else if (!regExp.hasMatch(value)) {
          return ApplicationTexts.EMAIL_EMPTY;
        } else {
          return null;
        }
      },
      controller: _emailController,
      style: applicationTheme.textTheme.overline,
      decoration: _buildInputDecoration(ApplicationTexts.EMAIL),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
        contentPadding: new EdgeInsets.fromLTRB(10, 30, 10, 20),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ApplicationColors.accentColorLight)),
        hintText: hint,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
        hintStyle: TextStyle(color: ApplicationColors.primaryTextColorLight),
        errorStyle: TextStyle(color: ApplicationColors.errorColor),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ApplicationColors.errorColor)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))));
  }

  void _onRegisterButtonPressed(
      String firstName, String lastName, String phone, String email) {
    registrationBloc
        .add(OnRegisterButtonPressed(firstName, lastName, phone, email));
  }
}
