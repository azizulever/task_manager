import 'package:flutter/material.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/model/task_list_model.dart';
import 'package:task_managment_apk/data/model/task_model.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/task_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  bool _getCanceledTaskListInProgress = false;
  List<TaskModel> _canceledTaskList = [];

  @override
  void initState() {
    _getCanceledTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCanceledTaskListInProgress,
      replacement: const CentreCircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: ()async{
          _getCanceledTaskList();
        },
        child: ListView.separated(
          itemCount: _canceledTaskList.length,
          itemBuilder: (context, index) {
            return  TaskCard(
                taskModel: _canceledTaskList[index],
              onRefreshList: _getCanceledTaskList,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 4,
            );
          },
        ),
      ),
    );
  }

  Future<void> _getCanceledTaskList() async {
    _getCanceledTaskListInProgress = true;
    _canceledTaskList.clear();
    setState(() {});

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getCanceledTaskList);


    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _canceledTaskList  = taskListModel.taskList ?? [];
    }else{
      snackBarMessage(context, response.errorMessage , true);
    }

    _getCanceledTaskListInProgress =false;
    setState(() {});
  }
}
