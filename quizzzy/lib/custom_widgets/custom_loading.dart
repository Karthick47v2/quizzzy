import 'package:flutter/material.dart';

import 'package:quizzzy/theme/palette.dart';

/// Customized circular loading.
class CustomLoading extends StatelessWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          color: Palette.theme, backgroundColor: Palette.loadingBg),
    );
  }
}
