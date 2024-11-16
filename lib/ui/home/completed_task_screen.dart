import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/completed_task_controller.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController _completedTaskController =
      Get.find<CompletedTaskController>();

  @override
  void initState() {
    _getCompletedTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompletedTaskController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CentreCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: () async {
            _getCompletedTaskList();
          },
          child: ListView.separated(
            itemCount: controller.completedTask.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: controller.completedTask[index],
                onRefreshList: _getCompletedTaskList,
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

  Future<void> _getCompletedTaskList() async {
    final bool result = await _completedTaskController.getCompletedTaskList();

    if (result == false) {
      snackBarMessage(context, _completedTaskController.errorMessage!, true);
    }
  }
}
