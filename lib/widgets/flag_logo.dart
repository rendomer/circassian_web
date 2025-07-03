import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlagLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/flag_logo.svg',
      width: 40,
      height: 40,
    );
  }
}