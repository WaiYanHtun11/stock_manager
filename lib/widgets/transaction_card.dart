import 'dart:math';

import 'package:flutter/material.dart';
class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key,required this.isRefill});
  final bool isRefill;

  @override
  Widget build(BuildContext context) {
    final Random random = Random();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          leading: Image.asset('assets/images/stock.png'),
          title: const Text('Stock Item...'),
          subtitle: RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: '${isRefill ? 'Refilled' : 'Removed'} at ',style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isRefill ? Colors.green : Colors.deepOrangeAccent
                  )),
                  const TextSpan(text: 'May 3,2024')
                ]
            ),
          ),
          trailing: CircleAvatar(
            backgroundColor: isRefill ? Colors.green : Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            child: Text('${random.nextInt(100)}'),
          ),
        ),
      ),
    );
  }
}
