import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/model/task_status_count_model.dart';
import 'package:task_managment_apk/data/model/task_status_model.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';

class TaskStatusListController extends GetxController{
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<TaskStatusModel> _taskStatusList = [];

  List<TaskStatusModel> get taskStatusList => _taskStatusList;



  Future<bool> getTaskStatusCount() async {
    bool isSuccess=  false;
    _inProgress = true;
    update();

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskStatusCount);

    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusList = taskStatusCountModel.taskStatusCountList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}