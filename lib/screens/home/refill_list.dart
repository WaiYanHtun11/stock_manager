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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const AddTransaction(status: 'refill')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
