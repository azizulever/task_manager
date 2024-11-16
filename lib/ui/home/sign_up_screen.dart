import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/sign_up_controller.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/screen_background.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final SignUpController _signUpController = Get.find<SignUpController>();

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
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Join With Us',
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSignUpFormSection(),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Column(
                    children: [
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

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        text: "Have account? ",
        children: [
          TextSpan(
              text: 'Sign In',
              style: const TextStyle(color: AppColor.themeColor),
              recognizer: TapGestureRecognizer()
                ..onTap = _onTapSignInButton),
        ],
      ),
    );
  }

  Widget _buildSignUpFormSection() {
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
              if (value?.isEmpty ?? true) {
                return 'Email is required';
              }
              if (!value!.contains('@')) {
                return 'Enter a valid Email "@"';
              }
              if (!value.contains('.com')) {
                return 'Enter a valid Email ".com"';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _firstNameTEController,
            decoration: const InputDecoration(
              hintText: 'First Name',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'First Name is required';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _lastNameTEController,
            decoration: const InputDecoration(
              hintText: 'Last Name',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Last Name is required';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _mobileTEController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Mobile',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Mobile is required';
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
            },
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<SignUpController>(
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

  void _onTapNextScreenButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    final bool result = await _signUpController.signUp(
      _emailTEController.text.trim(), _firstNameTEController.text.trim(),
      _lastNameTEController.text.trim(), _mobileTEController.text.trim(),
      _passwordTEController.text,);

    if (result) {
      _clearTextField();
      snackBarMessage(context, 'New user Created');
    } else {
      snackBarMessage(context, _signUpController.errorMessage!, true);
    }
  }

  void _clearTextField() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }


  void _onTapSignInButton() {
    // Navigator.pop(context);
    Get.back();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
