import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:staking_test/logic/constants.dart';

class UniswapIFrame extends StatefulWidget {
  const UniswapIFrame({Key? key}) : super(key: key);

  @override
  State<UniswapIFrame> createState() => _UniswapIFrameState();
}

class _UniswapIFrameState extends State<UniswapIFrame> {
  Widget? _iframeWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 800,
        height: 600,
        child: _iframeWidget,
      ),
    );
  }

  @override
  void initState() {
    final IFrameElement _iframeElement = IFrameElement();
    _iframeElement.width = '800';
    _iframeElement.height = '600';
    _iframeElement.src = 'https://app.uniswap.org/swap?outputCurrency=$contractAddress';
    _iframeElement.style.border = 'none';
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
        key: UniqueKey(),
        viewType: 'iframeElement');

    super.initState();
  }
}
