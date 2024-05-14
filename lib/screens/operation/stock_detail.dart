import 'package:flutter/material.dart';

class StockItemDetail extends StatelessWidget {
  final String name;
  final String count;
  final String location;

  const StockItemDetail({
    super.key,
    required this.name,
    required this.count,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Count',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              '$count items',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Location',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              location,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
