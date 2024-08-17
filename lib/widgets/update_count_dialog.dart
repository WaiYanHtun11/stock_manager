import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/daily_provider.dart';
import 'package:stock_manager/providers/out_of_stock_provider.dart';
import 'package:stock_manager/providers/reports_provider.dart';
import 'package:stock_manager/providers/stocks_provider.dart';
import 'package:stock_manager/services/database_service.dart';

class ItemCountDialog extends StatefulWidget {
  final Item item;

  const ItemCountDialog({super.key, required this.item});

  @override
  State<ItemCountDialog> createState() => _ItemCountDialogState();
}

class _ItemCountDialogState extends State<ItemCountDialog> {
  late int _newCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _newCount = widget.item.count;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.only(top: 32, left: 24, bottom: 16),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      title: const Text(
        'Update Item Count',
        style: TextStyle(fontSize: 20),
      ),
      content: _isLoading
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(24),
              height: 40,
              child: const SizedBox(
                  width: 24, height: 24, child: CircularProgressIndicator()))
          : TextFormField(
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
              keyboardType: TextInputType.number,
              autofocus: true,
              initialValue: _newCount.toString(),
              onChanged: (value) {
                setState(() {
                  _newCount = int.tryParse(value) ?? 0;
                });
              },
            ),
      actions: _isLoading
          ? null
          : <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Handle the update action here, for example, you can call a function to update the count

                  Item updateReport = widget.item;
                  int difference = _newCount - widget.item.count;

                  if (widget.item.count != _newCount) {
                    DatabaseService db = DatabaseService();
                    setState(() {
                      _isLoading = true;
                    });
                    updateReport.count = _newCount;
                    await Provider.of<ReportsManager>(context, listen: false)
                        .updateReport(
                            widget.item.sid!, updateReport, difference)
                        .then((value) async {});

                    final stock = await db.getStockById(updateReport.sid!);

                    if (stock != null && context.mounted) {
                      Provider.of<StocksManager>(context, listen: false)
                          .updateMemoryList(stock);
                      Provider.of<OutofStockManager>(context, listen: false)
                          .checkOutofStockAfterUpdate(stock);
                    }

                    if (context.mounted) {
                      if (updateReport.status == 'sale') {
                        Provider.of<DailyManager>(context, listen: false)
                            .updateSaleMemoryList(updateReport);
                      } else {
                        Provider.of<DailyManager>(context, listen: false)
                            .updateRefillMemoryList(updateReport);
                      }
                    }
                  }

                  if (context.mounted) Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
            ],
    );
  }
}
