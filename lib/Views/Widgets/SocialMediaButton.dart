import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nobile/Constants/Constants.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({
    super.key,
    required this.assetName,
    required this.onTap,
  });

  final String assetName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration:
            const BoxDecoration(color: colorNavBar, shape: BoxShape.circle),
        child: Center(
          child: SvgPicture.asset(
            assetName,
            // Assuming your SVG assets are the appropriate size, otherwise consider using `fit: BoxFit.scaleDown`
          ),
        ),
      ),
    );
  }
}
