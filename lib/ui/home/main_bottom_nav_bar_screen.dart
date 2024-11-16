import 'package:flutter/material.dart';
import 'package:task_managment_apk/ui/home/canceled_task_screen.dart';
import 'package:task_managment_apk/ui/home/completed_task_screen.dart';
import 'package:task_managment_apk/ui/home/new_task_screen.dart';
import 'package:task_managment_apk/ui/home/progress_task_screen.dart';
import 'package:task_managment_apk/ui/widget/tm_app_bar.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  static const String name = '/home';

  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screen = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),
    ProgressTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
          NavigationDestination(
              icon: Icon(Icons.check_box), label: 'Completed'),
          NavigationDestination(
              icon: Icon(Icons.cancel_presentation_rounded), label: 'Canceled'),
          NavigationDestination(
              icon: Icon(Icons.incomplete_circle), label: 'Progress'),
        ],
      ),
    );
  }
}


