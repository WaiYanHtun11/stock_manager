import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/edit_history.dart';
import 'package:stock_manager/utils/format_date.dart';

class EditHistoryCard extends StatelessWidget {
  final EditHistory editHistory;

  const EditHistoryCard({super.key, required this.editHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the main content in a ListTile
            ListTile(
              leading: CircleAvatar(
                radius: 32.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: editHistory.image,
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
              ),
              title: Text(editHistory.itemName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4.0),
                  Text(
                      'Count: ${editHistory.fromCount} -> ${editHistory.toCount}',
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4.0),
                  Text(
                    'Edited by ${editHistory.userName}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            // Display the time at the top
            Container(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              alignment: Alignment.centerRight,
              child: Text(
                formatDateTime(editHistory.time),
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
