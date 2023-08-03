import 'package:caco_cooking/widgets/texter.dart';
import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  final double dim20;
  final double dim12;

  const IconAndTextWidget({Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.dim20,
    required this.dim12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            flex: 0,
            child: Icon(icon, color: iconColor, size: dim20)
        ),
        const SizedBox(
          width: 2,
        ),
        Flexible(
            flex: 1,
            child: SmallText(text: text, size: dim12)
        )
      ],
    );
  }
}
