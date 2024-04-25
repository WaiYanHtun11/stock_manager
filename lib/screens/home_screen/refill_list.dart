import 'package:flutter/material.dart';
import 'package:stock_manager/widgets/transaction_card.dart';
class RefillList extends StatelessWidget {
  const RefillList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
          itemBuilder: (context,index){
            return const TransactionCard(isRefill: true);
          }
      ),
    );
  }
}
