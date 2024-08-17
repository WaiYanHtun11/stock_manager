import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/daily_provider.dart';
import 'package:stock_manager/providers/out_of_stock_provider.dart';
import 'package:stock_manager/providers/reports_provider.dart';
import 'package:stock_manager/providers/stocks_provider.dart';
import 'package:stock_manager/services/sqflite_service.dart';
import 'package:uuid/uuid.dart';

class AddTransaction extends StatefulWidget {
  final String status;
  final Item? item;
  const AddTransaction({super.key, required this.status, this.item});

  @override
  State<AddTransaction> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddTransaction> {
  late Future<List<Item>> _itemsFuture;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _showSuggestions = false;
  bool _isFieldEnabled = true;
  bool _isSaveButtonEnabled = false;
  bool _isSaving = false;
  Item? _selectedItem;

  SqfliteService db = SqfliteService();

  @override
  void initState() {
    super.initState();
    _itemsFuture = db.getAllItems('stocks');
    if (widget.item != null) {
      _selectedItem = widget.item;
      _searchController.text = widget.item!.name;
      _isFieldEnabled = false;
    }

    _searchController.addListener(_validateInputs);
    _countController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _isSaveButtonEnabled =
          _searchController.text.isNotEmpty && _countController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_validateInputs);
    _countController.removeListener(_validateInputs);
    _searchController.dispose();
    _countController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    setState(() {
      _isSaving = true;
    });

    final itemCount = int.tryParse(_countController.text) ?? 0;
    final note =
        _noteController.text.isNotEmpty ? _noteController.text : 'No note';

    String id = const Uuid().v1();
    Item item = Item(
        id: id,
        sid: _selectedItem!.id,
        name: _selectedItem!.name,
        count: itemCount,
        image: _selectedItem!.image,
        date: DateTime.now().toIso8601String(),
        timeStamp: DateTime.now().toIso8601String(),
        status: widget.status,
        note: note);

    if (_selectedItem != null && itemCount > 0) {
      // Save the transaction
      if (widget.status == 'sale') {
        await Provider.of<DailyManager>(context, listen: false)
            .addSale(_selectedItem!, item);
      } else {
        await Provider.of<DailyManager>(context, listen: false)
            .addRefill(_selectedItem!, item);
      }

      // Show the snackbar
      if (mounted) {
        if (widget.item != null) {
          Provider.of<DailyManager>(context, listen: false)
              .updateRefillMemoryList(item);
        }
        Provider.of<ReportsManager>(context, listen: false).addReport(item);
        Provider.of<StocksManager>(context, listen: false)
            .updateMemoryList(_selectedItem!);
        await Provider.of<OutofStockManager>(context, listen: false)
            .checkOutofStockAfterUpdate(_selectedItem!);

        if (mounted) {
          await Provider.of<StocksManager>(context, listen: false)
              .updateTotalStocks();
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } else {
      // Show the snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction Failed!'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
            margin: EdgeInsets.fromLTRB(16, 0, 16, 96),
          ),
        );
      }
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_selectedItem != null)
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: _selectedItem!.image,
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
                      title: Text(_selectedItem!.name),
                      subtitle: Text('${_selectedItem!.count} items'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFieldEnabled = true;
                            _searchController.clear();
                            _selectedItem = null;
                          });
                        },
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    if (_isFieldEnabled) {
                      setState(() {
                        _showSuggestions = value.isNotEmpty;
                        _itemsFuture =
                            db.getAllItems('stocks', searchTerm: value);
                      });
                    }
                  },
                  enabled: _isFieldEnabled,
                  decoration: const InputDecoration(
                    hintText: 'Search for items...',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _countController,
                  autofocus: !_isFieldEnabled,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Item count',
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                      labelText: 'Note',
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    onPressed: _isSaveButtonEnabled && !_isSaving
                        ? () async {
                            await _saveTransaction();
                          }
                        : null,
                    child: _isSaving
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(fontSize: 17),
                          ),
                  ),
                ),
              ],
            ),
            if (_showSuggestions)
              Positioned(
                left: 0,
                right: 0,
                top: 72, // Adjust this value based on your needs
                child: FutureBuilder<List<Item>>(
                  future: _itemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Center(child: Text('No such item')),
                      );
                    } else {
                      final items = snapshot.data!;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(items[index].name),
                              subtitle: Text('Count: ${items[index].count}'),
                              onTap: () {
                                // Handle item selection
                                _searchController.text = items[index].name;
                                setState(() {
                                  _selectedItem = items[index];
                                  _showSuggestions = false;
                                  _isFieldEnabled = false;
                                });
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
