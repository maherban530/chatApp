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
  static const Color primaryColorLight = Color.fromARGB(255, 19, 102, 94);
  static const Color primaryColorDark = Color.fromARGB(255, 7, 31, 33);

  static const Color accentColorLight = Color.fromARGB(255, 19, 102, 94);
  static const Color accentColorDark = Color.fromARGB(255, 7, 31, 33);

  static const Color backgroundLight = Color(0xFFF4F4F4);
  static const Color backgroundDark = Color.fromARGB(255, 10, 40, 44);
  static const Color gray = Color(0xFF999999);

  static const Color primaryTextColorLight = Color(0xFF282828);
  static const Color primaryTextColorDark = Color(0xFFFFFFFF);

  static const Color transparentColor = Colors.transparent;

  static const Color yellowColor = Color(0xFFE99A4A);
  static const Color errorColor = Color(0xFFff006e);

  static const Color blueColor = Color(0xFF16007e);
}

class ChatAppTheme {
  static get lightTheme {
    final themeData = ThemeData.light();
    final originalTextTheme = themeData.textTheme.copyWith(
        headline4:
            const TextStyle(color: ApplicationColors.primaryTextColorLight));
    return themeData.copyWith(
        primaryColor: ApplicationColors.primaryColorLight,
        scaffoldBackgroundColor: ApplicationColors.backgroundLight,
        backgroundColor: ApplicationColors.backgroundLight,
        primaryColorLight: ApplicationColors.backgroundDark,
        primaryColorDark: ApplicationColors.backgroundLight,
        dividerColor: ApplicationColors.gray,
        appBarTheme:
            const AppBarTheme(color: ApplicationColors.primaryColorLight),
        iconTheme: const IconThemeData(
            color: ApplicationColors.backgroundLight, size: 16),
        textTheme: originalTextTheme.copyWith(
          bodyText1: const TextStyle(
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 28,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          bodyText2: const TextStyle(
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 16,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          subtitle1: const TextStyle(
              color: ApplicationColors.primaryTextColorLight,
              fontSize: 14,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w400),
          headline1: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 28,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          headline2: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 16,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          headline3: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 14,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w400),
        ));
  }

  static get darkTheme {
    final themeData = ThemeData.dark();
    final originalTextTheme = themeData.textTheme.copyWith(
        headline4:
            const TextStyle(color: ApplicationColors.primaryTextColorDark));
    return themeData.copyWith(
        primaryColor: ApplicationColors.primaryColorDark,
        scaffoldBackgroundColor: ApplicationColors.backgroundDark,
        backgroundColor: ApplicationColors.backgroundDark,
        primaryColorLight: ApplicationColors.backgroundLight,
        primaryColorDark: ApplicationColors.backgroundDark,
        dividerColor: ApplicationColors.gray,
        appBarTheme:
            const AppBarTheme(color: ApplicationColors.primaryColorDark),
        iconTheme: const IconThemeData(
            color: ApplicationColors.backgroundLight, size: 16),
        textTheme: originalTextTheme.copyWith(
          bodyText1: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 28,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          bodyText2: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 16,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          subtitle1: const TextStyle(
            color: ApplicationColors.primaryTextColorDark,
            fontSize: 14,
            fontFamily: 'Maccabi',
            fontWeight: FontWeight.w400,
          ),
          headline1: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 28,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          headline2: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 16,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w700),
          headline3: const TextStyle(
              color: ApplicationColors.primaryTextColorDark,
              fontSize: 14,
              fontFamily: 'Maccabi',
              fontWeight: FontWeight.w400),
        ));
  }
}
