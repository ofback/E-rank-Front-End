// E-rank-Front-End/lib/navigation/main_navigator_screen.dart
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/home_screen.dart';
import 'package:erank_app/screens/profile/profile_screen.dart';
import 'package:erank_app/screens/social/social_screen.dart';
import 'package:flutter/material.dart';

class MainNavigatorScreen extends StatefulWidget {
  const MainNavigatorScreen({super.key});

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  int _selectedIndex = 0;

  // Lista das telas principais
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SocialScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // O body está limpo, sem SafeArea ou Center
      body: _widgetOptions.elementAt(_selectedIndex),

      // A barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        onTap: _onItemTapped,
        backgroundColor: AppColors.background,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
