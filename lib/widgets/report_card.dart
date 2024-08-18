import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/utils/format_date.dart';
import 'package:stock_manager/widgets/update_dialog.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.isRefill, required this.item});
  final bool isRefill;
  final Item item;

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () async {
            showModalBottomSheet(
              context: context,
              constraints: const BoxConstraints(maxWidth: 600),
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
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
                              width: 96.0,
                              height: 96.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(formatDate(item.date!)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Item : ${item.count} ${isRefill ? 'refilled' : 'sold'}',
                      ),
                      const SizedBox(height: 8),
                      Text('Time : ${formatTime(item.date!)}'),
                      const SizedBox(height: 8),
                      if (item.note != null && item.note!.isNotEmpty)
                        Text('Note : ${item.note}'),
                      if (authManager.role == 'admin')
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ItemCountDialog(item: item);
                                  },
                                );
                              },
                              child: const Text('Edit')),
                        ),
                    ],
                  ),
                );
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
          subtitle: Text(item.note!),
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
