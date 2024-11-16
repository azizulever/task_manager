import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment_apk/ui/controller/add_new_task_controller.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/tm_app_bar.dart';

class AddNewTaskBar extends StatefulWidget {
  const AddNewTaskBar({super.key});

  @override
  State<AddNewTaskBar> createState() => _AddNewTaskBarState();
}

class _AddNewTaskBarState extends State<AddNewTaskBar> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  final AddNewTaskController _addNewTaskController =
      Get.find<AddNewTaskController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _shouldRefreshPrevious = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshPrevious);
      },
      child: Scaffold(
          appBar: const TMAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 42,
                    ),
                    Text(
                      'Add New Task',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _titleTEController,
                      decoration: const InputDecoration(hintText: 'title'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty == true) {
                          return 'Enter a Title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _descriptionTEController,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty == true) {
                          return 'Enter a Description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GetBuilder<AddNewTaskController>(builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CentreCircularProgressIndicator(),
                        child: ElevatedButton(
                            onPressed: _onTapAddNewTaskButton,
                            child:
                                const Icon(Icons.arrow_circle_right_outlined)),
                      );
                    })
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _onTapAddNewTaskButton() {
    if (_formKey.currentState!.validate()) {
      _adNewTask();
    }
  }

  Future<void> _adNewTask() async {
    final bool result = await _addNewTaskController.adNewTask(
      _titleTEController.text,
      _descriptionTEController.text,
    );

    if (result) {
      _shouldRefreshPrevious = true;
      _clearTextField();
      snackBarMessage(context, 'New Task Add!');
    } else {
      snackBarMessage(context, _addNewTaskController.errorMessage!, true);
    }
  }

  void _clearTextField() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}