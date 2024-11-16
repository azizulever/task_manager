import 'package:flutter/material.dart';
import 'package:task_managment_apk/ui/home/splash_screen.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';

class TaskManager extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {

//  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      navigatorKey: TaskManager.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColor.themeColor,
        textTheme:  const TextTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData()
      ),
      home: const SplashScreen(),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10
    ),
    fixedSize: const Size.fromWidth(double.maxFinite),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8)
    )
    ),
    );
  }


  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder () {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }


}
