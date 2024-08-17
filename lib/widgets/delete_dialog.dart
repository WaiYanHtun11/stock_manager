import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.only(top: 32, left: 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      title: const Text(
        'Delete Item',
        style: TextStyle(fontSize: 22),
      ),
      content: const Text(
        'Are you sure you want to delete this item?',
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle the delete action here

            Navigator.of(context).pop(true);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
