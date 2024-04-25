import 'package:flutter/material.dart';
import 'package:stock_manager/models/constant.dart';
import 'package:stock_manager/screens/add_screen/add_new_stock.dart';
import 'package:stock_manager/widgets/stock_card.dart';
class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context,index){
            return const StockCard();
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          goToScreen(context, const AddNewStock());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
