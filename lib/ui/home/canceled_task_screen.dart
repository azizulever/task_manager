import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/canceled_task_controller.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/task_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  final CanceledTaskController _canceledTaskController =
      Get.find<CanceledTaskController>();

  @override
  void initState() {
    _getCanceledTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanceledTaskController>(builder: (controller) {
      return Visibility(
        visible: !controller.inProgress,
        replacement: const CentreCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: () async {
            _getCanceledTaskList();
          },
          child: ListView.separated(
            itemCount: controller.canceledTask.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: controller.canceledTask[index],
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
    });
  }

  Future<void> _getCanceledTaskList() async {
    final bool result = await _canceledTaskController.getCanceledTaskList();
    if (result == false) {
      snackBarMessage(context, _canceledTaskController.errorMessage!, true);
    }
  }
}
