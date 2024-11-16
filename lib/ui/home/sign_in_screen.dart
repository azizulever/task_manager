import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/sign_in_controller.dart';
import 'package:task_managment_apk/ui/home/forgot_password_email_screen.dart';
import 'package:task_managment_apk/ui/home/main_bottom_nav_bar_screen.dart';
import 'package:task_managment_apk/ui/home/sign_up_screen.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/screen_background.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  static const String name = '/signIn';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final SignInController signInController = Get.find<SignInController>();

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
                  'Get Started With',
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSignInFormSection(),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _onTapForgotPasswordButton,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      _buildSignUpSection(),
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

  Widget _buildSignInFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            validator: (String? value) {
              if (value!.isEmpty == true) {
                return 'Enter 6 digit password';
              }
              if (value.length <= 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<SignInController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inProgress,
                replacement: const CentreCircularProgressIndicator(),
                child: ElevatedButton(
                  onPressed: _onTapNextScreenButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        text: "Don't have an account? ",
        children: [
          TextSpan(
              text: 'Sign Up',
              style: const TextStyle(color: AppColor.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton),
        ],
      ),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgotPasswordEmailScreen(),
        ));
  }

  void _onTapNextScreenButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    final bool result = await signInController.signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );

    if (result) {
      Get.offAllNamed(MainBottomNavBarScreen.name);
      snackBarMessage(context, 'Login Successful');
    } else {
      snackBarMessage(context, signInController.errorMessage!, true);
    }
  }

  void _onTapSignUpButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        ));
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
