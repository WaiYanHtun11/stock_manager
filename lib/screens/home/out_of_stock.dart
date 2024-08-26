import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/out_of_stock_provider.dart';
import 'package:stock_manager/widgets/out_of_stock_card.dart';

class OutofStockScreen extends StatefulWidget {
  const OutofStockScreen({super.key});

  @override
  State<OutofStockScreen> createState() => _OutofStockScreenState();
}

class _OutofStockScreenState extends State<OutofStockScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        final outofStockManager = context.read<OutofStockManager>();
        if (!outofStockManager.isLoading) {
          await outofStockManager.syncOutofStockData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Out of Stock Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Consumer<OutofStockManager>(
        builder: (context, outofStockManager, _) {
          if (outofStockManager.isLoading &&
              outofStockManager.outofStocks.isEmpty) {
            return const Center(
              child: Text('Loading...'),
            );
          }

          if (outofStockManager.outofStocks.isEmpty) {
            return const Center(
              child: Text('No out of stock items'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            itemCount: outofStockManager.outofStocks.length +
                (outofStockManager.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == outofStockManager.outofStocks.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final item = outofStockManager.outofStocks[index];
              return OutofStockCard(
                item: item,
              );
            },
          );
        },
      ),
    );
  }
}
