import 'package:flutter/material.dart';
import 'package:task_manager/view/home_page.dart';
import 'package:task_manager/view/main_screen.dart';


Route<dynamic>? generateRoute(RouteSettings settings){
  switch(settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const BottonNavigationBarPage());
    case "homePage":
      return MaterialPageRoute(builder: (_) => const HomePage());
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
