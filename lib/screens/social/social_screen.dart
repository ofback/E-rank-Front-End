import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/social/tabs/friends_tab.dart';
import 'package:erank_app/screens/social/tabs/requests_tab.dart';
import 'package:erank_app/screens/social/tabs/search_tab.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          flexibleSpace: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.grey,
                tabs: [
                  Tab(icon: Icon(Icons.search), text: 'Buscar'),
                  Tab(icon: Icon(Icons.people), text: 'Amigos'),
                  Tab(icon: Icon(Icons.mail), text: 'Convites'),
                ],
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SearchTab(),
            FriendsTab(),
            RequestsTab(),
          ],
        ),
      ),
    );
  }
}
