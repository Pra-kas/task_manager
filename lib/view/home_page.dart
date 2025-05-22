import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/themes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String calculateDayandMonth() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d').format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/homepage_notifications.svg',
              ),
            ),
          ),
        ],
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, "todoPage"),
            child: SvgPicture.asset('assets/icons/homepage_menu.svg'),
          ),
        ),
        centerTitle: true,
        title: Text(
          calculateDayandMonth(),
          style: TextStyle(fontFamily: "bold"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/homepage_container.svg',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Let’s make a\t\nhabits together  🙌",
                    style: TextStyle(fontSize: 25, fontFamily: "semibold"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProjectContainer extends StatelessWidget {
  const ProjectContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedBottomNavBarColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}