import 'package:flutter/material.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/model/task_list_model.dart';
import 'package:task_managment_apk/data/model/task_model.dart';
import 'package:task_managment_apk/data/model/task_status_count_model.dart';
import 'package:task_managment_apk/data/model/task_status_model.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';
import 'package:task_managment_apk/ui/home/add_new_task_bar.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/task_card.dart';
import 'package:task_managment_apk/ui/widget/task_summery_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListInProgress = false;
  bool _getTaskStatusListInProgress = false;
  List<TaskModel> _newTaskList = [];
  List<TaskStatusModel> _taskStatuasCountList = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarSection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListInProgress,
                replacement: const CentreCircularProgressIndicator(),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: _newTaskList[index],
                      onRefreshList: _getNewTaskList,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 4,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFAB,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarSection() {
    return Visibility(
      visible: !_getTaskStatusListInProgress,
      replacement: const CentreCircularProgressIndicator(),
      child:  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _getTaskSummaryCardList(),
        ),
      ),
    );
  }

  List<TaskSummeryCard> _getTaskSummaryCardList(){
    List<TaskSummeryCard> taskSummaryCardList = [];
    for(TaskStatusModel t in _taskStatuasCountList){
      taskSummaryCardList.add(TaskSummeryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummaryCardList;
  }

  Future<void> _onTapFAB() async {
    final bool? shouldRefresh = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddNewTaskBar()));

    if (shouldRefresh == true) {
      _getNewTaskList();
    }
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    _newTaskList.clear();
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.getNewTaskList);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }

    _getNewTaskListInProgress = false;
    setState(() {});
  }

  Future<void> _getTaskStatusCount() async {
    _getTaskStatusListInProgress = true;
    _taskStatuasCountList.clear();
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskStatusCount);

    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
          TaskStatusCountModel.fromJson(response.responseData);
      _taskStatuasCountList = taskStatusCountModel.taskStatusCountList ?? [];
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }

    _getTaskStatusListInProgress = false;
    setState(() {});
  }
}
