import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';

class ResetPasswordController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> setNewPassword(String userEmail, String otp, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": userEmail,
      "OTP": otp,
      'password': password,
    };


    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPassword,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }

}