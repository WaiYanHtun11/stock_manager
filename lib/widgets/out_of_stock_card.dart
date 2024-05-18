import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/screens/operation/add_transaction.dart';
import 'package:stock_manager/utils/format_date.dart';

class OutofStockCard extends StatelessWidget {
  const OutofStockCard({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTransaction(
                          status: 'refill',
                          item: item,
                        )));
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: item.image,
              placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  color: Colors.grey.shade100,
                  child: const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ))),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/stock.png'),
              width: 48.0,
              height: 48.0,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(item.name),
          subtitle: Text(formatDate(item.timeStamp.toString())),
          trailing: CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            child: Text(item.count.toString()),
          ),
        ),
      ),
    );
  }
}
