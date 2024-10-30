import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/custom_drawer/custom_drawer.dart';
import '../../models/stores/stores_manager.dart';
import 'components/stores_card.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Lojas"),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storeManager, __) {
          if (storeManager.stores.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color.fromARGB(100, 73, 5, 182)),
              ),
            );
          }
          return ListView.builder(
            itemCount: storeManager.stores.length,
            itemBuilder: (_, index) {
              return StoresCard(storeManager.stores[index]);
            },
          );
        },
      ),
    );
  }
}
