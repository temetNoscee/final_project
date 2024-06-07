import 'package:final_project/screens/home.dart';
import 'package:final_project/signup.dart';
import 'package:flutter/material.dart';
// import 'package:final_project/welcome.dart';
import 'package:final_project/login.dart';
import 'package:final_project/screens/bottom_nav.dart';

//import 'package:final_project/screens/profile.dart';
void main() {
  runApp(const SpendWise());
}

class SpendWise extends StatefulWidget {
  const SpendWise({super.key});

  @override
  SpendWiseState createState() => SpendWiseState();
}

class SpendWiseState extends State<SpendWise> {
  //Default tema
  ThemeData _themeData = ThemeData.light();

  //Açık tema özellikleri
  final ThemeData _lightTheme = ThemeData.light().copyWith(
    iconTheme: const IconThemeData(color: Colors.black),
    primaryIconTheme: const IconThemeData(color: Colors.black),
  );
  //Koyu tema özellikleri
  final ThemeData _darkTheme = ThemeData.dark().copyWith(
      iconTheme: const IconThemeData(color: Colors.white),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)));

  //Tema değişimini gerçekleştiren fonksiyon
  void toggleTheme() {
    setState(() {
      _themeData =
          _themeData.brightness == Brightness.dark ? _lightTheme : _darkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Uygulamanın teması
      theme: _themeData,

      //Routing
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        //'/profile': (context) => Profile(toggleTheme: toggleTheme),
        // '/location': (context) => const Location(),
        '/signup': (context) => const Signup(),
        '/bottom': (context) => const Bottom(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
