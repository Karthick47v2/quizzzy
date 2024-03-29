import 'package:flutter/material.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:share_plus/share_plus.dart';

import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when [Share] button pressed.
class ShareQuizPopup extends StatelessWidget {
  final String quizName;
  const ShareQuizPopup({Key? key, required this.quizName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var code = '${FirestoreService().user!.uid}-$quizName';
    FirestoreService().generateQuiz(quizName);
    Share.share(code);

    return CustomPopup(size: 400.0, wids: [
      const RenderImage(
        path: 'assets/images/share.svg',
        expaned: false,
        svgHeight: 200,
      ),
      Text(
        "Code: $code",
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 19,
          fontWeight: Font.regular,
          color: Palette.font,
        ),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}
