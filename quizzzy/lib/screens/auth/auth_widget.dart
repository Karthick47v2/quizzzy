import 'package:flutter/material.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/custom_widgets/quizzzy_logo.dart';
import 'package:quizzzy/screens/auth/validation.dart';

class AuthWidget extends StatefulWidget {
  final String pageTitle;
  final VoidCallback? primaryBtnFunc;
  final String bottomBtnTxt;
  final String bottomText;
  final VoidCallback? hyperLinkFunc;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> gkey;
  const AuthWidget(
      {Key? key,
      required this.pageTitle,
      required this.primaryBtnFunc,
      required this.bottomBtnTxt,
      required this.bottomText,
      required this.hyperLinkFunc,
      required this.emailController,
      required this.passwordController,
      required this.gkey})
      : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomTemplate(body: Builder(builder: (context) {
      return Form(
        key: widget.gkey,
        child: Column(
          children: [
            const QuizzzyLogo(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Text(
                        widget.pageTitle,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontFamily: 'Heebo',
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(204, 79, 0, 170)),
                      ),
                    ),
                  ],
                ),
                CustomTextInput(
                    text: "Email",
                    controller: widget.emailController,
                    validator: validateEmail),
                CustomTextInput(
                    text: "Password",
                    controller: widget.passwordController,
                    validator: validatePassword,
                    isPass: true),
              ],
            ),
            Container(
              height: 50,
              width: double.maxFinite - 20,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: CustomButton(
                text: widget.pageTitle,
                onTap: widget.primaryBtnFunc,
              ),
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.bottomText,
                    style: const TextStyle(
                        fontFamily: 'Heebo',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 18),
                  TextButton(
                      child: Text(
                        widget.bottomBtnTxt,
                        style: const TextStyle(
                            fontFamily: 'Heebo',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 114, 0, 190)),
                      ),
                      onPressed: widget.hyperLinkFunc),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }
}
