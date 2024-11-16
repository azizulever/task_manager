import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/progress_task_controller.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTaskController _progressTaskController =
      Get.find<ProgressTaskController>();

  @override
  void initState() {
    _getProgressTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressTaskController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CentreCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: () async {
            _getProgressTaskList();
          },
          child: ListView.separated(
            itemCount: controller.progressList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: controller.progressList[index],
                onRefreshList: _getProgressTaskList,
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
    });
  }

  Future<void> _getProgressTaskList() async {
    final bool result = await _progressTaskController.getProgressTaskList();
    if (result == false) {
      snackBarMessage(context, _progressTaskController.errorMessage!, true);
    }
  }
}
