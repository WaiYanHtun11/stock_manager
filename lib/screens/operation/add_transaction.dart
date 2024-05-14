import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/sqflite_service.dart';
import 'package:stock_manager/utils/format_date.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddTransaction> {
  late Future<List<Item>> _itemsFuture;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
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
    super.dispose();
  }

  void _saveTransaction() async {
    setState(() {
      _isSaving = true;
    });

    final itemCount = int.tryParse(_countController.text) ?? 0;

    if (_selectedItem != null && itemCount > 0) {
      // Save the transaction
      await Future.delayed(const Duration(seconds: 2));

      // Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction saved successfully!'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 96),
        ),
      );

      // Reset the state
      setState(() {
        _searchController.clear();
        _countController.clear();
        _selectedItem = null;
        _isFieldEnabled = true;
        _isSaveButtonEnabled = false;
        _isSaving = false;
      });
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_selectedItem != null)
                  Card(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
                      leading: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  _selectedItem!.image,
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(4)),
                        width: 48,
                        height: 48,
                      ),
                      title: Text(_selectedItem!.name),
                      subtitle:
                          Text(formatDate(DateTime.now().toIso8601String())),
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Item count',
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    onPressed: _isSaveButtonEnabled && !_isSaving
                        ? _saveTransaction
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
