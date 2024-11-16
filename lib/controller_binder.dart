import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/add_new_task_controller.dart';
import 'package:task_managment_apk/ui/controller/canceled_task_controller.dart';
import 'package:task_managment_apk/ui/controller/completed_task_controller.dart';
import 'package:task_managment_apk/ui/controller/forgot_password_email_controller.dart';
import 'package:task_managment_apk/ui/controller/forgot_password_otp_controller.dart';
import 'package:task_managment_apk/ui/controller/new_task_list_controller.dart';
import 'package:task_managment_apk/ui/controller/progress_task_controller.dart';
import 'package:task_managment_apk/ui/controller/reset_password_controller.dart';
import 'package:task_managment_apk/ui/controller/sign_in_controller.dart';
import 'package:task_managment_apk/ui/controller/sign_up_controller.dart';
import 'package:task_managment_apk/ui/controller/task_status_list_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(TaskStatusListController());
    Get.put(CompletedTaskController());
    Get.put(CanceledTaskController());
    Get.put(ProgressTaskController());
    Get.put(SignUpController());
    Get.put(AddNewTaskController());
    Get.put(ForgotPasswordEmailController());
    Get.put(ForgotPasswordOTPController());
    Get.put(ResetPasswordController());
  }
}