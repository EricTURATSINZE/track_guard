import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:incident_tracker/views/incidents.dart';
import 'package:incident_tracker/views/profile_screen.dart';
import 'package:incident_tracker/views/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPage = 0;

  final List<Widget> _pages = const [
    IncidentsPage(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryGrey2,
        body: _pages[currentPage],
        floatingActionButton: currentPage != 0
            ? null
            : Visibility(
                visible: !(MediaQuery.of(context).viewInsets.bottom > 0),
                child: FloatingActionButton(
                  backgroundColor: splashColor,
                  onPressed: () {
                    context.push(AppRoutes.addIncidentScreen);
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
          selectedItemColor: splashColor,
          backgroundColor: primaryGrey2,
          unselectedItemColor: Colors.grey,
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
        ),
      ),
    );
  }
}
