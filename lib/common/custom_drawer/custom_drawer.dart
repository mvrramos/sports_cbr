import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/user_manager.dart';
import 'custom_drawer_header.dart';
import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const CustomDrawerHeader(),
          const DrawerTile(Icons.home, "Início", 0),
          const DrawerTile(Icons.list, "Produtos", 1),
          const DrawerTile(Icons.playlist_add_check, "Meus pedidos", 2),
          const DrawerTile(Icons.location_on, "Loja", 3),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return const Column(
                  children: [
                    Divider(),
                    DrawerTile(Icons.settings, "Usuários", 4),
                    DrawerTile(Icons.settings, "Pedidos da loja", 5),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          // DrawerTile(Icons.person, "Perfil", 6),
        ],
      ),
    );
  }
}
