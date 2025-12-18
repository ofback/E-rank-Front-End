import 'package:erank_app/screens/social/tabs/friends_tab.dart';
import 'package:erank_app/screens/social/tabs/requests_tab.dart';
import 'package:erank_app/screens/social/tabs/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'SOCIAL',
          style: GoogleFonts.bevan(
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          labelStyle: GoogleFonts.exo2(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'AMIGOS'),
            Tab(text: 'BUSCAR'),
            Tab(text: 'SOLICITAÇÕES'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_neon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            FriendsTab(),
            SearchTab(),
            RequestsTab(),
          ],
        ),
      ),
    );
  }
}
