import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final double size;
  final Color? col;
  final TextAlign? textAlign;

  const BigText({Key? key,
    required this.text,
    required this.size,
    this.col,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.firstUpper,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: largeTextStyle(context, size, col),
    );
  }
}

class MainBigText extends StatelessWidget {
  final String text;
  final double size;
  final TextOverflow overflow;

  const MainBigText({Key? key,
    required this.text,
    required this.size,
    this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.firstUpper,
      overflow: overflow,
      style: largeMainTextStyle(context, size),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;
  final double size;
  final double height;
  final int maxLines;
  final TextOverflow overflow;

  const SmallText({Key? key,
    required this.text,
    required this.size,
    this.height = 1.2,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: smallTextStyle(context, size),
      overflow: overflow,
    );
  }
}

class SmallTextMulti extends StatelessWidget {
  final String text;
  final double size;
  final double height;

  const SmallTextMulti({Key? key,
    required this.text,
    required this.size,
    this.height = 1.2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: smallTextStyle(context, size),
      textAlign: TextAlign.start,
    );
  }
}
