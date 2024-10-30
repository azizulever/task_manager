import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title of the Task',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Text('Description of Task'),
            const Text('Date: 12/12/2024'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    IconButton(
                      onPressed: () => _onTapEditButton(context),
                      icon: const Icon(Icons.edit_note),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEditButton(BuildContext context) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Status'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Cancel')),
          TextButton(onPressed: () {}, child: const Text('Okay')),
        ],
      );
    });
  }
  void _onTapDeleteButton() {}

  Widget _buildTaskStatusChip() {
    return Chip(
      label: const Text(
        'New',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(color: AppColors.themeColor),
    );
  }
}
