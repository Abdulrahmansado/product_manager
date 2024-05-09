import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:product_manager/screens/sign_in_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar', 'AR'),
        startLocale: const Locale('ar', 'AR'),
        useOnlyLangCode: true,
        saveLocale: true,
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dentist Directory',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        // primarySwatch: Colors.grey,
        // brightness: Brightness.dark,
        unselectedWidgetColor: const Color(0xFF333333),
        primaryColor: const Color(0xFFffffff),
        primaryColorDark: const Color(0xFF813892),
        primaryColorLight: const Color(0xFFC7C7C6),
        indicatorColor: const Color(0xFF333333),
        highlightColor: const Color(0xFFffffff),
        cardColor: const Color(0xFFfbfbfb),
        scaffoldBackgroundColor: const Color(0xFFffffff),
        splashColor: const Color(0xFFffffff),
        tabBarTheme: const TabBarTheme(
            labelColor: Color(0xFF813892),
            labelStyle: TextStyle(color: Color(0xFF813892)), // color for text
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFF813892)))),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xFF813892), circularTrackColor: Color(0xFFC7C7C6)),
     
      ),
      home: const SignInScreen(),
    );
  }
}