import 'package:carry_on_timetable/branch_page.dart';
import 'package:carry_on_timetable/home_page.dart';
import 'package:carry_on_timetable/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? name = prefs.getString('username');
  runApp(MyApp(startScreen: name == null ? LoginPage() : BranchPage()));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: startScreen);
  }
}
