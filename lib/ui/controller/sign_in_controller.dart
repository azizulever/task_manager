import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/login_model.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';
import 'package:task_managment_apk/ui/controller/auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  String? get errorMessage=> _errorMessage;

  bool get inProgress => _inProgress;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.logIn,
      body: requestBody,
    );

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.data!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
