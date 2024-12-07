import 'package:flutter/material.dart';
import 'package:turn_rating_launcher/reports.dart';
import 'package:turn_rating_launcher/services_page.dart';
import 'package:turn_rating_launcher/users.dart';

import 'categories.dart';
import 'gallery.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Define the selected index for the menu
  int selectedIndex = 0;

  // List of pages to show
  final List<Widget> pages = [
    const Categories(),
    ServicesPage(),
    const Users(),
    const Reports(),
    const Gallery(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Right-side menu
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView(
              children: [
                const SizedBox(
                  height: 24.0,
                ),
                MenuItem(
                  title: 'دسته بندی ها',
                  icon: Icons.category,
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                MenuItem(
                  title: 'خدمات',
                  icon: Icons.home_repair_service_outlined,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                MenuItem(
                  title: 'کاربران',
                  icon: Icons.supervised_user_circle_sharp,
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                MenuItem(
                  title: 'گزارشات',
                  icon: Icons.report,
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                MenuItem(
                  title: 'گالری',
                  icon: Icons.image,
                  isSelected: selectedIndex == 4,
                  onTap: () {
                    setState(() {
                      selectedIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),

          // Left-side content
          Expanded(
            child: Container(
              color: Colors.white,
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

// Menu item widget
class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black),
      title: Text(
        title,
        style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: "medium",
            fontSize: 20.0),
      ),
      onTap: onTap,
    );
  }
}
