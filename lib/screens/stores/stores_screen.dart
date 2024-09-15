import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/common/custom_drawer/custom_drawer.dart';
import 'package:sportscbr/models/store_manager.dart';
import 'package:sportscbr/screens/stores/components/store_card.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

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
      body: Consumer<StoreManager>(
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
              return StoreCard(storeManager.stores[index]);
            },
          );
        },
      ),
    );
  }
}
