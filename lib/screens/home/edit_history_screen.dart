import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/edit_provider.dart';
import 'package:stock_manager/widgets/edit_history_card.dart';

class EditHistoryList extends StatefulWidget {
  const EditHistoryList({super.key});

  @override
  State<EditHistoryList> createState() => _EditHistoryListState();
}

class _EditHistoryListState extends State<EditHistoryList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        final editHistoryProvider = context.read<EditHistoryProvider>();
        if (!editHistoryProvider.isLoading) {
          await editHistoryProvider.loadMoreEditHistories();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Histories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Consumer<EditHistoryProvider>(
          builder: (context, editHistoryProvider, _) {
        // Show loading if data is being fetched and the list is still empty
        if (editHistoryProvider.isLoading &&
            editHistoryProvider.editHistories.isEmpty) {
          return const Center(
            child: Text('Loading...'),
          );
        }

        // Show a message if there's no history after loading
        if (editHistoryProvider.editHistories.isEmpty) {
          return const Center(
            child: Text('No History Yet'),
          );
        }

        // Display the list of edit histories
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: editHistoryProvider.editHistories.length +
              (editHistoryProvider.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == editHistoryProvider.editHistories.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final editHistory = editHistoryProvider.editHistories[index];
            return EditHistoryCard(editHistory: editHistory);
          },
        );
      }),
    );
  }
}
