import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/screens/operation/stock_detail.dart';

class StaffStockCard extends StatelessWidget {
  final Item item;
  const StaffStockCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 12,
        surfaceTintColor: Colors.white,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
