import 'package:flutter/material.dart';
import 'package:task_manager/view/add_task_page.dart';
import 'package:task_manager/view/home_page.dart';
import 'package:task_manager/view/main_screen.dart';
import 'package:task_manager/view/todo_page.dart';


Route<dynamic>? generateRoute(RouteSettings settings){
  switch(settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const BottonNavigationBarPage());
    case "homePage":
      return MaterialPageRoute(builder: (_) => const HomePage());
    case "todoPage":
      return MaterialPageRoute(builder: (_) => const TodoPage());
    case "addTask":
      return MaterialPageRoute(builder: (_) => const AddTask());
    default:
      return null;
  }
}



void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      initialRoute: '/',
    ),
  );
}
