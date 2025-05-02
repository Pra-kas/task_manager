import 'package:flutter/material.dart';
import 'package:task_manager/view/home_page.dart';

class BottonNavigationBarPage extends StatefulWidget {
  const BottonNavigationBarPage({super.key});

  @override
  State<BottonNavigationBarPage> createState() =>
      _BottonNavigationBarPageState();
}

class _BottonNavigationBarPageState extends State<BottonNavigationBarPage> {
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  List<Widget> pages = [
    const HomePage(),
    const Center(child: Text('Search')),
    const Center(child: Text('Notifications')),
    const Center(child: Text('Profile')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => onTap(value),
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
