import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sportscbr/common/custom_drawer/custom_drawer.dart';
import 'package:sportscbr/common/custom_drawer/order/orders_tile.dart';
import 'package:sportscbr/common/custom_icon_button.dart';
import 'package:sportscbr/models/admin_orders_manager.dart';
import 'package:sportscbr/models/orders/orders.dart';
import 'package:sportscbr/screens/cart/components/empty_card.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Resumo dos pedidos"),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: _panelController,
            body: Column(
              children: [
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Pedidos de ${ordersManager.userFilter?.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        CustomIconButton(Icons.close, Colors.white, () {
                          ordersManager.setUserFilter(null);
                        }),
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  const Expanded(
                    child: EmptyCard(
                      title: "Nenhuma venda realizada!",
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, index) => OrdersTile(
                        filteredOrders[index],
                        showControls: true,
                      ),
                    ),
                  ),
                const SizedBox(height: 100)
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_panelController.isPanelClosed) {
                      _panelController.open();
                    } else {
                      _panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: const Text(
                      "Filtros",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        value: ordersManager.statusFilter.contains(s),
                        title: Text(Orders.getStatusText(s)),
                        dense: true,
                        onChanged: (v) {
                          ordersManager.setStatusFilter(
                            status: s,
                            enabled: v,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
