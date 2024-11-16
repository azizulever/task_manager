import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_managment_apk/ui/controller/auth_controller.dart';
import 'package:task_managment_apk/ui/home/main_bottom_nav_bar_screen.dart';
import 'package:task_managment_apk/ui/home/sign_in_screen.dart';
import 'package:task_managment_apk/ui/utils/assets_path.dart';
import 'package:task_managment_apk/ui/widget/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _nextScreenMove();
    super.initState();
  }

    Future<void> _nextScreenMove() async {
    await Future.delayed(const Duration(seconds: 3));

    await AuthController.getAccessToken();
    if(AuthController.isLoggedIn()){
      await AuthController.getUserModel();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavBarScreen(),
          ));
    }else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetsPath.logoSvg,
              width: 140,
            ),
          ],
        ),
      ),
    ));
  }
}
