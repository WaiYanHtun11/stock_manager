import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/utils/format_date.dart';
import 'package:stock_manager/widgets/update_count_dialog.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {super.key, required this.isRefill, required this.item});
  final bool isRefill;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ItemCountDialog(currentCount: 18);
              },
            );
          },
          leading: Image.asset('assets/images/stock.png'),
          title: Text(item.name),
          subtitle: Text(formatDate(item.timeStamp.toString())),
          trailing: CircleAvatar(
            backgroundColor: isRefill ? Colors.green : Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            child: Text(item.count.toString()),
          ),
        ),
      ),
    );
  }
}
