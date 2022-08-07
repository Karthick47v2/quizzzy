import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Free sized logo.
class RenderImage extends StatelessWidget {
  final String path;
  final bool expaned;
  final double? pngHeight;
  final double? svgHeight;
  final double? svgWidth;
  final Color? color;
  const RenderImage(
      {Key? key,
      required this.path,
      required this.expaned,
      this.pngHeight,
      this.svgHeight,
      this.svgWidth,
      this.color})
      : super(key: key);

  Widget renderPng() {
    return Image.asset(
      path,
      color: color,
      height: pngHeight,
    );
  }

  Widget renderSvg() {
    return SvgPicture.asset(
      path,
      width: svgWidth,
      height: svgHeight,
      fit: BoxFit.scaleDown,
    );
  }

  Widget renderExpandedWidget(Widget child) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      child: child,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget media = Container(
        padding: const EdgeInsets.all(10.0),
        child: path.split('.')[1] == 'png' ? renderPng() : renderSvg());

    return expaned ? renderExpandedWidget(media) : media;
  }
}
