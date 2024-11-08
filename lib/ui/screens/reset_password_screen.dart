import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.userEmail, required String this.otp});
  final String userEmail;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPassTEController = TextEditingController();
  bool _setPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),
                Text(
                  'Set Password',
                  style: textTheme.titleLarge
                      ?.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum numbers of password should be 8 characters',
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildResetPasswordForm(),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      _buildSignInSection(),
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

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have an Account? ",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        children: [
          TextSpan(
              text: "Sign In",
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()
                ..onTap = _onTapSignIn),
        ],
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (String? value) {
              if (value?.isEmpty == true) {
                return "Enter Password";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPassTEController,
            decoration: const InputDecoration(hintText: 'Confirm Password'),
            validator: (String? value) {
              if (value?.isEmpty == true) {
                return "Enter Password Again";
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !_setPasswordInProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    _setPassword();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (_) => false,
    );
  }

  Future<void> _setPassword() async {
    if(_passwordTEController.text != _confirmPassTEController) {
      return;
    }
    _setPasswordInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
    'email' : widget.userEmail,
    'OTP' : widget.otp,
    'password' : _passwordTEController.text
    };

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.recoverResetPassword,
    body: requestBody);
    if(response.isSuccess) {
      showSnackBarMessage(context, 'New Password Set');
    } else {
    showSnackBarMessage(context, response.errorMessage, true);
    }
    _setPasswordInProgress = false;
    setState(() {});
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (_) => false,
    );
  }

  @override
  void dispose() {
    _passwordTEController.dispose;
    _confirmPassTEController.dispose();
    super.dispose();
  }
}
