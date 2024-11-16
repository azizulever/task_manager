import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_managment_apk/ui/utils/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Stack(
        children: [
          SvgPicture.asset(
            AssetsPath.backGroundSvg,
            fit: BoxFit.cover,
            height: screenSize.height,
            width: screenSize.width,
          ),
          child,
        ],
      ),
    );
  }
}