import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/custom_drawer/custom_drawer.dart';
import '../../models/admin_orders_manager.dart';
import '../../models/page_manager.dart';
import '../../models/user/admin_users_manager.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Usuários"),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __) {
          return AlphabetListScrollView(
            strList: adminUsersManager.names,
            indexedHeight: (index) => 80.0, 
            normalTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
            highlightTextStyle: const TextStyle(fontSize: 20, color: Colors.green),
            showPreview: true,
            itemBuilder: (context, index) {
              if (index < adminUsersManager.users.length) {
                return ListTile(
                  title: Text(
                    adminUsersManager.users[index].name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  subtitle: Text(
                    adminUsersManager.users[index].email ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    try {
                      context.read<AdminOrdersManager>().setUserFilter(adminUsersManager.users[index]);
                      context.read<PageManager>().setPage(5);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao definir o filtro do usuário: $e')),
                      );
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
