import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/model/task_list_model.dart';
import 'package:task_managment_apk/data/model/task_model.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';

class CompletedTaskController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel> _completedTask = [];
  List<TaskModel> get completedTask => _completedTask;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getCompletedTaskList);


    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _completedTask  = taskListModel.taskList ?? [];
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _inProgress =false;
    update();
    return isSuccess;
  }


}