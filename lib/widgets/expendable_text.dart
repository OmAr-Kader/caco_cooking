import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final Widget? additionalWidget;

  const ExpandableText({Key? key, required this.text, this.additionalWidget}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends GlobalMainState<ExpandableText> {
  var firstHalf = "";
  var secondHalf = "";

  late ExpandableTextNotifier stateNot;

  @override
  void initState() {
    stateNot = emptyStateNot();
    super.initState();
  }

  var boolHiddenText = true;

  double get textHeight => sizer(80);

  ExpandableTextNotifier emptyStateNot() => ExpandableTextNotifier(update: setState);

  @override
  Widget buildWid(BuildContext context, isPortrait, Size size) {
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
    Widget? additionalWidget = widget.additionalWidget;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: secondHalf.isEmpty
          ? SmallTextMulti(text: firstHalf, size: dim15)
          : Column(
        children: [
          additionalWidget ?? Container(),
          SmallTextMulti(
              size: dim15,
              text: boolHiddenText
                  ? ("$firstHalf...")
                  : firstHalf + secondHalf),
          secondHalf.isEmpty
              ? Container()
              : InkWell(
            onTap: () {
              setState(() {
                boolHiddenText = !boolHiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(
                    size: dim15,
                    text:
                    boolHiddenText ? "Show More" : "Show Less"),
                Icon(
                    boolHiddenText
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: mainColor)
              ],
            ),
          )
        ],
      ),
    );
  }

}

class ExpandableTextNotifier {

  Function update;

  ExpandableTextNotifier({required this.update});

  bool _boolHiddenText = false;

  bool get boolHiddenText => _boolHiddenText;

  set boolHiddenText(bool newValue) {
    update(() => { _boolHiddenText = newValue});
  }
}
