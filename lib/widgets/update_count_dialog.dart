import 'package:flutter/material.dart';

class ItemCountDialog extends StatefulWidget {
  final int currentCount;

  const ItemCountDialog({super.key, required this.currentCount});

  @override
  State<ItemCountDialog> createState() => _ItemCountDialogState();
}

class _ItemCountDialogState extends State<ItemCountDialog> {
  late int _newCount;

  @override
  void initState() {
    super.initState();
    _newCount = widget.currentCount;
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
      content: TextFormField(
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
        keyboardType: TextInputType.number,
        autofocus: true,
        initialValue: _newCount.toString(),
        onChanged: (value) {
          setState(() {
            _newCount = int.tryParse(value) ?? 0;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_newCount);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle the update action here, for example, you can call a function to update the count
            print('Updated item count: $_newCount');
            Navigator.of(context).pop(_newCount);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
