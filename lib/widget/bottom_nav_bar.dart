// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:sportify/screens/edit_profile.dart';
import 'package:sportify/screens/profile_show.dart';
import "package:get/get.dart";

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Get.to(()=>const ProfilePage());
        break;
      case 1:
        // Get.to(()=>BuddiesPage());
        break;
      case 2:
        // Get.to(()=>DiscoverPage());
        break;
      case 3:
        Get.to(()=>SettingsForm());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Buddies'),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Discover'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}