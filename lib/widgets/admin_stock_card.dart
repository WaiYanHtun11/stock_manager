import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/stocks_provider.dart';
import 'package:stock_manager/screens/operation/edit_stock.dart';
import 'package:stock_manager/screens/operation/stock_detail.dart';
import 'package:stock_manager/widgets/delete_dialog.dart';

List<PopupMenuItem<String>> getPopupItems(BuildContext context, Item item) {
  List<PopupMenuItem<String>> popupMenuItems = [];
  List<Map<String, dynamic>> actions = [
    {
      'name': 'Update',
      'icon': Icons.update, // Assuming icons is a map of icons
      'onPressed': () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditStock(
                      stock: item,
                    )));
      },
    },
    {
      'name': 'Delete',
      'icon': Icons.delete,
      'onPressed': () async {
        // Handle action 2 press
        bool isDeleted = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const DeleteDialog();
          },
        );
        if (isDeleted && context.mounted) {
          Provider.of<StocksManager>(context, listen: false).deleteStock(item);
        }
      },
    },
  ];
  for (Map<String, dynamic> action in actions) {
    popupMenuItems.add(
      PopupMenuItem<String>(
        value: action['name'],
        onTap: action['onPressed'],
        child: ListTile(
          leading: Icon(action['icon']),
          title: Text(action['name']),
        ),
      ),
    );
  }
  return popupMenuItems;
}

class AdminStockCard extends StatelessWidget {
  final Item item;
  const AdminStockCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StockItemDetail(
                        name: item.name,
                        count: item.count.toString(),
                        location: item.location!)));
          },
          leading: Image.asset('assets/images/stock.png'),
          title: const Text('Stock Item...'),
          subtitle: const Text('5 Items at Container 3................'),
          trailing: PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return getPopupItems(context, item);
            },
          ),
        ),
      ),
    );
  }
}
