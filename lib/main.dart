import 'package:edrawer/constants/theme.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:edrawer/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

late bool initScreen;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (await prefs.getBool('boolValue') == null) {
    initScreen = false;
  } else {
    initScreen = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //ajouter sharedpreference pour pas l'avoir tt le temps
      home: initScreen ? const HomePage() : const OnBoardingPage(),
    );
  }
}
