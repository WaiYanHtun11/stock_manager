import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/screens/operation/stock_detail.dart';

class StaffStockCard extends StatelessWidget {
  final Item item;
  final VoidCallback clearFoucs;
  const StaffStockCard(
      {super.key, required this.item, required this.clearFoucs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 12,
        surfaceTintColor: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          onTap: () {
            clearFoucs();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StockItemDetail(
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
              width: 56.0,
              height: 56.0,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(item.name),
          subtitle: Text(
            '${item.count} items at ${item.location}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
