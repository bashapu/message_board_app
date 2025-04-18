import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/home_page.dart';
import './screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Board App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (ctx) => SplashScreen(),
        '/login': (ctx) => LoginScreen(),
        '/register': (ctx) => RegisterScreen(),
        '/home': (ctx) => HomePage(),
        '/settings': (ctx) => SettingsScreen(),
      },
    );
  }
}
