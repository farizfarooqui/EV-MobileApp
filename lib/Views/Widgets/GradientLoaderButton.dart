import 'package:flutter/material.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';

class GradientLoaderButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final double fontsize;

  const GradientLoaderButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.green, Color.fromARGB(255, 3, 114, 21)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: SmallLoader(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontsize,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
