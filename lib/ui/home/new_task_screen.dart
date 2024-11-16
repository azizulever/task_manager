import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/data/model/task_status_model.dart';
import 'package:task_managment_apk/ui/controller/new_task_list_controller.dart';
import 'package:task_managment_apk/ui/controller/task_status_list_controller.dart';
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
  final TaskStatusListController _taskStatusListController =
      Get.find<TaskStatusListController>();
  final NewTaskListController _newTaskListController =
      Get.find<NewTaskListController>();

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
              child: GetBuilder<NewTaskListController>(builder: (controller) {
                return Visibility(
                  visible: !controller.inProgress,
                  replacement: const CentreCircularProgressIndicator(),
                  child: ListView.separated(
                    itemCount: controller.taskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: controller.taskList[index],
                        onRefreshList: _getNewTaskList,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 4,
                      );
                    },
                  ),
                );
              }),
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
    return GetBuilder<TaskStatusListController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CentreCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummaryCardList(),
          ),
        ),
      );
    });
  }

  List<TaskSummeryCard> _getTaskSummaryCardList() {
    List<TaskSummeryCard> taskSummaryCardList = [];
    for (TaskStatusModel t in _taskStatusListController.taskStatusList) {
      taskSummaryCardList
          .add(TaskSummeryCard(title: t.sId!, count: t.sum ?? 0));
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
    final bool result = await _newTaskListController.getNewTaskList();

    if (result == false) {
      snackBarMessage(context, _newTaskListController.errorMessage!, true);
    }
  }

  Future<void> _getTaskStatusCount() async {
    final bool result = await _taskStatusListController.getTaskStatusCount();

    if (result == false) {
      snackBarMessage(context, _taskStatusListController.errorMessage!, true);
    }
  }
}
