import 'package:erank_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/screens/profile/profile_screen.dart';
import 'package:erank_app/screens/social/social_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Por enquanto, apenas uma lista de widgets simples para cada página
  static const List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text('Página de Início',
          style: TextStyle(color: AppColors.white, fontSize: 24)),
    ),
    SocialScreen(),
    Center(
      child: Text('Página de Times',
          style: TextStyle(color: AppColors.white, fontSize: 24)),
    ),
    ProfileScreen(),
    Center(
      child: Text('Página Social (Amigos)',
          style: TextStyle(color: AppColors.white, fontSize: 24)),
    ),
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
      appBar: AppBar(
        title: const Text('E-Rank'),
        backgroundColor: AppColors.background,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove a seta de "voltar"
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Times',
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
      ),
    );
  }
}
