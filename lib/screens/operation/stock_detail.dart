import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/screens/operation/edit_stock.dart';

class StockItemDetail extends StatelessWidget {
  final Item item;

  const StockItemDetail({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditStock(stock: item)));
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 320.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      color: Colors.grey.shade100,
                      child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ))),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/stock.png'),
                  width: 320,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            const Text(
              'Name',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              item.name,
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
              '${item.count} items',
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
              item.location!,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
