import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'global_state.dart';

abstract class WebKeyWidgetDim<T extends StatefulWidget> extends GlobalMainState<T> {
  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @protected
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size);

  void _handleKeyEvent(RawKeyEvent event) {
    var offset = _controller.offset;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _controller.animateTo(offset - 100, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _controller.animateTo(offset + 100, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
      _controller.animateTo(offset + 400, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
      _controller.animateTo(offset - 400, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return Scaffold(
        body: RawKeyboardListener(
            autofocus: true,
            focusNode: _focusNode,
            onKey: _handleKeyEvent,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _controller, child: buildWidScroll(context, isPortrait, size)
            )
        ));
  }
}
