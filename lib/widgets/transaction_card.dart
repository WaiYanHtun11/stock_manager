import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/utils/format_date.dart';
import 'package:stock_manager/widgets/update_count_dialog.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {super.key, required this.isRefill, required this.item});
  final bool isRefill;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ItemCountDialog(item: item);
              },
            );
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
            backgroundColor: isRefill ? Colors.green : Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            child: Text(item.count.toString()),
          ),
        ),
      ),
    );
  }
}
