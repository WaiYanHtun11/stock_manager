import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/reports_provider.dart';
import 'package:stock_manager/utils/format_date.dart';
import 'package:stock_manager/widgets/transaction_card.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReportsManager>(builder: (context, reportsManager, _) {
        print(reportsManager.reportsList);
        if (reportsManager.isLoading) {
          return const Center(
            child: Text('Loading...'),
          );
        }
        if (reportsManager.reportsList.isEmpty) {
          return const Center(
            child: Text('No Items Yet'),
          );
        }
        print(reportsManager.reportsList.length);
        return ListView.builder(
          itemCount: reportsManager.reportsList.length,
          itemBuilder: (context, index) {
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
                    return TransactionCard(
                      isRefill: item.status == 'sale',
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
