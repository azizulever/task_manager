import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';
import 'package:task_managment_apk/ui/home/reset_password_screen.dart';
import 'package:task_managment_apk/ui/home/sign_in_screen.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';
import 'package:task_managment_apk/ui/widget/screen_background.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  const ForgotPasswordOTPScreen( {required this.userEmail} );

  final String userEmail;

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  bool _getOTPInProgress = false;
  final TextEditingController _otpTEController = TextEditingController();


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
                  'Pin Verification',
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification pin has been sent to your email address',
                  style: textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildSignUpFormSection(),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 36),
                      _buildVerifyEmailForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpFormSection() {
    return Column(
      children: [
        PinCodeTextField(
          controller: _otpTEController,
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            inactiveFillColor: Colors.white,
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _onTapNextScreenButton(widget.userEmail),
          child: const Text('Verify'),
        ),
      ],
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

  void _onTapNextScreenButton(String userEmail) {
    _getOTP();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  ResetPasswordScreen(
           userEmail: userEmail,
          otp: _otpTEController.text
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (_) => false,
    );
  }

  Future<void> _getOTP() async {
    _getOTPInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getOTPVerify(widget.userEmail, _otpTEController.text.trim()),
    );

    if (response.isSuccess) {
      snackBarMessage(context, "OTP Verified");
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }

    _getOTPInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}

