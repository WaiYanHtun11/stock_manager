import 'package:flutter/material.dart';
import '../../widgets/transaction_card.dart';
class RemoveList extends StatelessWidget {
  const RemoveList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context,index){
            return const TransactionCard(isRefill: false);
          }
      ),
    );
  }
}
