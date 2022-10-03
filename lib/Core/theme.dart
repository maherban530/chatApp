import 'package:flutter/material.dart';

class ApplicationSizes {
  //general border and blure radius for elements in the app
  static const double borderRadius = 10.0;
  //general element padding
  static const double padding = 8.0;
  //general element padding
  static const double horizontalPadding = 16.0;
  //general element padding
  static const double verticalPadding = 12.0;
  //icon side padding
  static const double iconSidePadding = 3.0;
  //page side padding
  static const double pageSidePadding = 24.0;
  //page top padding
  static const double pageTopPadding = 40.0;
  //page bottom padding
  static const double pageBottomPadding = 40.0;
  //round buttons radius
  static const double roundButtonRadius = 15.0;
}

class ApplicationColors {
  static final Color primaryColorLight = Color(0xFF0489C2);
  static final Color primaryColorDark = Color(0xFF0489C2);

  static final Color accentColorLight = Color(0xFF0489C2);
  static final Color accentColorDark = Color(0xFF0489C2);

  static final Color backgroundLight = Color(0xFFF4F4F4);
  static final Color backgroundDark = Color(0xFFF4F4F4);
  static final Color gray = Color(0xFF999999);

  static final Color primaryTextColorLight = Color(0xFF282828);
  static final Color primaryTextColorDark = Color(0xFF282828);

  static final Color transparentColor = Color(0xFFFFFFFFFF);

  static final Color yellowColor = Color(0xFFE99A4A);
  static final Color errorColor = Color(0xFFff006e);

  static final Color blueColor = Color(0xFF16007e);
}

class ChatAppTheme {
  static get lightTheme {
    final themeData = ThemeData.light();
    final originalTextTheme = themeData.textTheme.copyWith(
        headline4: TextStyle(color: ApplicationColors.primaryTextColorLight));
    return themeData.copyWith(
        primaryColor: ApplicationColors.primaryColorLight,
        scaffoldBackgroundColor: ApplicationColors.transparentColor,
        accentColor: ApplicationColors.accentColorLight,
        backgroundColor: ApplicationColors.backgroundLight,
        textTheme: originalTextTheme.copyWith(
          headline1: TextStyle(
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 28,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          bodyText1: TextStyle(
              height: 1.5,
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 16,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          bodyText2: TextStyle(
              color: ApplicationColors.primaryTextColorLight,
              height: 1.4,
              fontSize: 14,
              letterSpacing: 0.14,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w400),
          overline: TextStyle(
              height: 1.2,
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 14,
              letterSpacing: 0.1,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w300),
        ));
  }

  static get darkTheme {
    final themeData = ThemeData.dark();
    final originalTextTheme = themeData.textTheme.copyWith(
        headline4: TextStyle(color: ApplicationColors.primaryTextColorDark));
    return themeData.copyWith(
        primaryColor: ApplicationColors.primaryColorDark,
        scaffoldBackgroundColor: ApplicationColors.transparentColor,
        accentColor: ApplicationColors.accentColorDark,
        backgroundColor: ApplicationColors.backgroundDark,
        textTheme: originalTextTheme.copyWith(
          headline1: TextStyle(
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 28,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          bodyText1: TextStyle(
              height: 1.5,
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 16,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          bodyText2: TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              height: 1.4,
              fontSize: 14,
              letterSpacing: 0.14,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w400),
          caption: TextStyle(
            color: ApplicationColors.primaryColorDark,
            fontSize: 12,
            fontFamily: 'Maccabi',
            fontWeight: FontWeight.w700,
          ),
          overline: TextStyle(
              height: 1.2,
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 14,
              letterSpacing: 0.1,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w300),
        ));
  }
}
