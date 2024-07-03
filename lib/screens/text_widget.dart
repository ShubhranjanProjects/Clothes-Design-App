import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String displayText;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  Color? fontColor;
  final Color fontBackgroundColor;
  TextWidget({
    super.key,
    required this.displayText,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 12,
    this.textAlign = TextAlign.left,
    this.fontColor,
    this.fontBackgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      displayText,
      textAlign: textAlign,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: fontColor,
            backgroundColor: fontBackgroundColor),
      ),
    );
  }
}
