import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/out_of_stock_provider.dart';
import 'package:stock_manager/widgets/out_of_stock_card.dart';

class OutofStockScreen extends StatelessWidget {
  const OutofStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Out of Stock Items'),
      ),
      body: Consumer<OutofStockManager>(
        builder: (context, outofStockManager, _) {
          return _buildOutofStockList(outofStockManager.outofStocks);
        },
      ),
    );
  }

  Widget _buildOutofStockList(List<Item> outofStocks) {
    if (outofStocks.isEmpty) {
      return const Center(
        child: Text('No out of stock items'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        itemCount: outofStocks.length,
        itemBuilder: (context, index) {
          final item = outofStocks[index];
          return OutofStockCard(
            item: item,
          );
        },
      );
    }
  }
}
