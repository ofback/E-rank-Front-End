// E-rank-Front-End/lib/screens/social/social_screen.dart
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/social/tabs/friends_tab.dart';
import 'package:erank_app/screens/social/tabs/requests_tab.dart';
import 'package:erank_app/screens/social/tabs/search_tab.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. O DefaultTabController continua sendo o widget raiz, o que é ótimo.
    return DefaultTabController(
      length: 3,
      // 2. Substituímos o Scaffold e AppBar aninhados por um Column simples.
      //    Isso resolve o conflito de layout e o overflow.
      child: Column(
        children: [
          // 3. A TabBar se torna a primeira filha do Column.
          //    Envolvemos em um Container para dar a cor de fundo.
          Container(
            color: AppColors.background,
            child: const TabBar(
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
          ),

          // 4. O TabBarView precisa ser envolvido em um Expanded
          //    para que ele preencha todo o espaço restante no Column.
          const Expanded(
            child: TabBarView(
              children: [
                SearchTab(),
                FriendsTab(),
                RequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
