import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';

class ForgotPasswordOTPController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage=>_errorMessage;

  Future<bool> getOTP(String userEmail, String otp) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getOTPVerify(userEmail , otp),
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