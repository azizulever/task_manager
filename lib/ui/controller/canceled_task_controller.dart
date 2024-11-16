import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/model/task_list_model.dart';
import 'package:task_managment_apk/data/model/task_model.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';

class CanceledTaskController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage =>_errorMessage;

  List<TaskModel> _canceledTask = [];
  List<TaskModel> get canceledTask => _canceledTask;


  Future<bool> getCanceledTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getCanceledTaskList);


    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _canceledTask  = taskListModel.taskList ?? [];
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _inProgress =false;
    update();

    return isSuccess;
  }

}