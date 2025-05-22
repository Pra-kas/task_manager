import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/bloc/add_task_bloc/add_task_bloc.dart';
import 'package:task_manager/themes/colors.dart';
import 'package:task_manager/view/add_task_page.dart';
import 'package:task_manager/view/home_page.dart';

class BottonNavigationBarPage extends StatefulWidget {
  const BottonNavigationBarPage({super.key});

  @override
  State<BottonNavigationBarPage> createState() =>
      _BottonNavigationBarPageState();
}

class _BottonNavigationBarPageState extends State<BottonNavigationBarPage> {
  int currentIndex = 0;
  bool isBottomSheetOpen = false;

  void onTap(int index) async {
    if (index == 2) {
      setState(() => isBottomSheetOpen = true);

      await showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: false,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "addTask"),
                        builder:
                            (_) => BlocProvider(
                              create: (_) => AddTaskBloc(),
                              child: AddTask(),
                            ),
                      ),
                    );

                    setState(() => isBottomSheetOpen = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset("assets/icons/create_task.svg"),
                      title: const Text(
                        'Create New Task',
                        style: TextStyle(fontFamily: "medium"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      setState(() => isBottomSheetOpen = false);
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    const HomePage(),
    const Center(child: Text('Search')),
    const Center(child: Text('Notifications')),
    const Center(child: Text('Analytics')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: (value) => onTap(value),
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              "assets/icons/bottom_nav_bar_active_home.svg",
            ),
            icon: SvgPicture.asset("assets/icons/bottom_nav_bar_home.svg"),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              "assets/icons/bottom_nav_bar_active_project_management.svg",
            ),
            icon: SvgPicture.asset(
              "assets/icons/bottom_nav_bar_project_management.svg",
            ),
            label: "Project",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 25,
              backgroundColor: selectedBottomNavBarColor,
              child: AnimatedRotation(
                turns: isBottomSheetOpen ? 0.125 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset("assets/icons/bottom_nav_bar_add.svg"),
              ),
            ),
            activeIcon: CircleAvatar(
              radius: 25,
              backgroundColor: selectedBottomNavBarColor,
              child: AnimatedRotation(
                turns: isBottomSheetOpen ? 0.125 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset("assets/icons/bottom_nav_bar_add.svg"),
              ),
            ),
            label: "add",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_sharp),
            activeIcon: Icon(
              Icons.analytics_sharp,
              color: selectedBottomNavBarColor,
            ),
            label: "analytics",
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              "assets/icons/bottom_nav_bar_active_profile.svg",
            ),
            icon: SvgPicture.asset("assets/icons/bottom_nav_bar_profile.svg"),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
