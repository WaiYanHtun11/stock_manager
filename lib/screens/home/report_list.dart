import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/reports_provider.dart';
import 'package:stock_manager/utils/format_date.dart';
import 'package:stock_manager/widgets/report_card.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
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
        final reportsManager = context.read<ReportsManager>();
        if (!reportsManager.isLoading &&
            reportsManager.currentPage < reportsManager.totalPages) {
          await reportsManager.loadMoreReports();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReportsManager>(builder: (context, reportsManager, _) {
        if (reportsManager.isLoading && reportsManager.reportsList.isEmpty) {
          return const Center(
            child: Text('Loading...'),
          );
        }
        if (reportsManager.reportsList.isEmpty) {
          return const Center(
            child: Text('No History Yet'),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: reportsManager.reportsList.length +
              (reportsManager.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == reportsManager.reportsList.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              );
            }

            final reportsMap = reportsManager.reportsList[index];
            final date = reportsMap.keys.first;
            final items = reportsMap[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Text(
                    formatDate(date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ReportCard(
                      isRefill: item.status != 'sale',
                      item: item,
                    );
                  },
                ),
                const SizedBox(height: 16), // Add space between each map
              ],
            );
          },
        );
      }),
    );
  }
}
