import 'package:flutter/material.dart';
import 'package:product_manager/res/custom_color.dart';
class AppBarTitle  extends StatelessWidget {
  const AppBarTitle ({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/firebase_logo.png',
          height: 20,
        ),
        const SizedBox(width: 8),
        const Text(
          'FlutterFire',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
        const Text(
          ' Authentication',
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
