import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/forgot_password_email_controller.dart';
import 'package:task_managment_apk/ui/home/forgot_password_otp_screen.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';
import 'package:task_managment_apk/ui/widget/screen_background.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  static const String name = '/forgotPasswordEmail';

  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final ForgotPasswordEmailController _forgotPasswordEmailController =
      Get.find<ForgotPasswordEmailController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Your Email Address',
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'A 6 digit verification pin will send to your email address',
                  style: textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildForgotPassswordEmailSection(),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 36,
                      ),
                      _buildVerifyEmailForm(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassswordEmailSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value!.isEmpty == true) {
                return 'Enter a valid Email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<ForgotPasswordEmailController>(builder: (controller) {
            return Visibility(
              visible: !controller.inProgress,
              replacement: const CircularProgressIndicator(),
              child: ElevatedButton(
                onPressed: _onTapNextScreenButton,
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVerifyEmailForm() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        text: "Have account? ",
        children: [
          TextSpan(
              text: 'Sign In',
              style: const TextStyle(color: AppColor.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton),
        ],
      ),
    );
  }

  void _onTapNextScreenButton() {
    if (_formKey.currentState!.validate()) {
      _getVerifyEmail();


      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOTPScreen(
                userEmail: _emailTEController.text.trim()),
          ));
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  Future<void> _getVerifyEmail() async {
    final bool result = await _forgotPasswordEmailController
        .getVerifyEmail(_emailTEController.text);
    if (result) {
      _clearTextField();
    } else {
      snackBarMessage(
          context, _forgotPasswordEmailController.errorMessage!, true);
    }
  }

  void _clearTextField() {
    _emailTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
