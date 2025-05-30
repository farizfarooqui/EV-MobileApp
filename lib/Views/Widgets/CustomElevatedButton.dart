import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback onpress;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  TextAlign? textalign;
  Color? borderColor;

  final bool loading;
  dynamic radious;
  final double? maxHeight;
  final String? iconPath;
  final double? margin;
  final double? fontsize;
  final FontWeight? fontWeight;
  // final TextStyle? textColor;
  CustomElevatedButton(
      {super.key,
      this.text,
      required this.onpress,
      this.backgroundColor,
      this.borderColor,
      this.textalign,
      this.maxHeight,
      this.iconPath,
      this.fontsize,
      this.elevation,
      this.textColor,
      this.loading = false,
      this.radious,
      this.margin,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: elevation,
            side: BorderSide(color: borderColor ?? Colors.transparent),
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor ?? Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  radious ?? 32), // Match the border radius from the image
            ),
            // Adjust padding to match the image

            textStyle: TextStyle(
                fontSize: fontsize ?? 16.0,
                fontWeight:
                    fontWeight ?? FontWeight.w600 // The size of the text
                // fontWeight: FontWeight.w400, // The weight of the font
                ),
            maximumSize: Size(double.infinity, maxHeight ?? 56),
            minimumSize: Size(double.infinity, maxHeight ?? 56),
            disabledForegroundColor: Colors.grey[500],
            disabledBackgroundColor:
                (backgroundColor ?? Colors.white).withOpacity(0.6)),
        onPressed: loading ? null : onpress,
        child: loading
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 18.0),
                child: buildLoader(context),
              )
            : iconPath != null
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          iconPath!,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          text ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: fontWeight ?? null),
                        ),
                      ],
                    ),
                  )
                : Text(
                    text ?? '',
                    textAlign: textalign ?? TextAlign.start,
                    style: TextStyle(
                        color: textColor ?? Colors.black,
                        fontWeight: fontWeight ?? null),
                  ),
      ),
    );
  }

  Widget buildLoader(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return AspectRatio(
      aspectRatio: 1,
      child: isIOS
          ? const CupertinoActivityIndicator()
          : const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
    );
  }
}
