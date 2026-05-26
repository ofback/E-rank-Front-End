import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/challenges/challenges_hub_screen.dart';
import 'package:erank_app/screens/home_screen.dart';
import 'package:erank_app/screens/profile/profile_screen.dart';
import 'package:erank_app/screens/ranking/ranking_screen.dart';
import 'package:erank_app/screens/social/social_screen.dart';
import 'package:erank_app/screens/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navegador principal do app com 5 abas:
/// Início | Desafios | Stats | Social | Perfil
class MainNavigatorScreen extends StatefulWidget {
  const MainNavigatorScreen({super.key});

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ChallengesHubScreen(),
    StatsScreen(),
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
      body: Stack(
        children: [
          // Background neon global aplicado uma única vez no nível do navigator
          Positioned.fill(
            child: Image.asset(
              'assets/background_neon.png',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(color: AppColors.background),
            ),
          ),
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.shield_outlined),
              activeIcon: const Icon(Icons.shield),
              label: 'Times',
              tooltip: 'Meus Times',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: const [
                  Icon(Icons.sports_kabaddi_outlined),
                ],
              ),
              activeIcon: const Icon(Icons.sports_kabaddi),
              label: 'Desafios',
              tooltip: 'Desafios e Partidas',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              activeIcon: const Icon(Icons.bar_chart),
              label: 'Stats',
              tooltip: 'Estatísticas',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people),
              label: 'Social',
              tooltip: 'Amigos',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'Perfil',
              tooltip: 'Meu Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textDisabled,
          backgroundColor: AppColors.background.withValues(alpha: 0.95),
          selectedLabelStyle:
              GoogleFonts.exo2(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.exo2(fontSize: 10),
          elevation: 0,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
