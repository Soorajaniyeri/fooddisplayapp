import 'package:flutter/material.dart';
import 'package:foodmanagement/views/userprofile.dart';

import 'homescreen.dart';
import 'menuscreen.dart';

class BottomHome extends StatefulWidget {
  const BottomHome({super.key});

  @override
  State<BottomHome> createState() => _BottomHomeState();
}

int index = 0;
List screens = [HomeScreens(), MenuScreen(), UserPage()];

class _BottomHomeState extends State<BottomHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              index = value;
              setState(() {});
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "menu"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  label: "userprofile"),
            ]),
        body: screens[index]);
  }
}
