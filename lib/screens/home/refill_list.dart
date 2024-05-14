import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/daily_provider.dart';
import 'package:stock_manager/screens/operation/add_transaction.dart';
import 'package:stock_manager/widgets/transaction_card.dart';

class RefillList extends StatelessWidget {
  const RefillList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DailyManager>(builder: (context, dailyManager, _) {
        final items = dailyManager.refills;
        if (dailyManager.refills.isEmpty) {
          return const Center(
            child: Text('No Items Yet'),
          );
        }
        return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return TransactionCard(
                isRefill: true,
                item: item,
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTransaction()));
          // String id = const Uuid().v4();
          // Provider.of<ReportsManager>(context, listen: false).addReport(Item(
          //     id: id,
          //     name: "shoes",
          //     count: 10,
          //     status: 'refill',
          //     image:
          //         "https://firebasestorage.googleapis.com/v0/b/stock-manager-4a814.appspot.com/o/images%2Fimage_1714804355339.jpg?alt=media&token=d0d0052e-9d04-4193-8347-6d66b8087799",
          //     timeStamp: DateTime.now().toIso8601String()));
          // await Provider.of<DailyManager>(context, listen: false).addRefill(
          //     Item(
          //         id: "1bab5ad5-fe2c-43ed-bee3-30695cb90187",
          //         name: "shoes",
          //         count: 25,
          //         image:
          //             "https://firebasestorage.googleapis.com/v0/b/stock-manager-4a814.appspot.com/o/images%2Fimage_1714804355339.jpg?alt=media&token=d0d0052e-9d04-4193-8347-6d66b8087799",
          //         timeStamp: "2024-05-04T13:32:45.261289"),
          //     Item(
          //         id: id,
          //         name: "shoes",
          //         count: 10,
          //         status: 'refill',
          //         image:
          //             "https://firebasestorage.googleapis.com/v0/b/stock-manager-4a814.appspot.com/o/images%2Fimage_1714804355339.jpg?alt=media&token=d0d0052e-9d04-4193-8347-6d66b8087799",
          //         timeStamp: DateTime.now().toIso8601String()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
