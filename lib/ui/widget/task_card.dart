import 'package:flutter/material.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/model/task_model.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';
import 'package:task_managment_apk/ui/widget/app_color.dart';
import 'package:task_managment_apk/ui/widget/centre_circular_progress_indicator.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskModel, required this.onRefreshList,
  });

  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  String _selectedStatus = '';
  bool _changedStatusInProgress = false;
  bool _deleteTaskInProgress = false;


  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
             widget.taskModel.description ?? '',
            ),
            Text(
              'Date : ${widget.taskModel.createdDate ?? ''}'
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: !_changedStatusInProgress,
                      replacement: const CentreCircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapEditButton,
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    Visibility(
                      visible: !_deleteTaskInProgress,
                      replacement: const CentreCircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapDeleteButton,
                        icon: const Icon(Icons.delete),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['New', 'Completed', 'Canceled', 'Progress'].map((e){
                return ListTile(
                  onTap: (){
                    _onChangedStatus(e);
                    Navigator.pop(context);
                  },
                  title: Text(e),
                  selected: _selectedStatus == e,
                  trailing: _selectedStatus == e ? const Icon(Icons.check) : null,
                );
              }).toList(),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: const Text('Cancel')),
            ],
          );
        });
  }

  Future<void> _onTapDeleteButton() async {
    _deleteTaskInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteStatus(widget.taskModel.sId!));
    if(response.isSuccess){
      widget.onRefreshList();
    }else{
      snackBarMessage(context, response.errorMessage, true);
    }
    _deleteTaskInProgress = false;
    setState(() {});

  }

  Widget _buildStatusChip() {
    return Chip(
      label:  Text(
        widget.taskModel.status!,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(
        color: AppColor.themeColor,
      ),
    );
  }

  Future<void> _onChangedStatus (String newStatus) async {
     _changedStatusInProgress = true;
    setState(() {});

     final NetworkResponse response = await NetworkCaller.getRequest(
         url: Urls.changedStatus(widget.taskModel.sId!, newStatus));

     if(response.isSuccess){
        widget.onRefreshList();
     }else{
       _changedStatusInProgress = false;
       setState(() {});
       snackBarMessage(context, response.errorMessage, true);
     }

  }
}
