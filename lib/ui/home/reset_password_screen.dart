import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/reset_password_controller.dart';
import 'package:task_managment_apk/ui/home/sign_in_screen.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/screen_background.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {

  // final String name = '/resetPassword';

  const ResetPasswordScreen(
      {super.key, required this.userEmail, required this.otp});

  final String userEmail;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final ResetPasswordController _resetPasswordController =
      Get.find<ResetPasswordController>();

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
                  'Minimum number of password should be 8 latter',
                  style: textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildResetPasswordSection(),
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

  Widget _buildResetPasswordSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordTEController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Password is required';
                }
                if (value!.length <= 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              }),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _confirmPasswordTEController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Password is required';
                }
                if (value!.length <= 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              }),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<ResetPasswordController>(builder: (controller) {
            return Visibility(
              visible: !controller.inProgress,
              replacement: const CentreCircularProgressIndicator(),
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
      _setNewPassword();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (_) => false);
    }
  }

  void _onTapSignInButton() {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => const SignInScreen()),
    //     (_) => false);
    Get.to(SignInScreen.name);
  }

  Future<void> _setNewPassword() async {
    if (_passwordTEController.text != _confirmPasswordTEController.text) {
      snackBarMessage(context, 'Password do not match', true);
      return;
    }

    final bool result = await _resetPasswordController.setNewPassword(
        widget.userEmail, widget.otp, _passwordTEController.text);

    if (result) {
      snackBarMessage(context, 'Reset Password');
    } else {
      snackBarMessage(context, _resetPasswordController.errorMessage!, true);
    }
  }
}
