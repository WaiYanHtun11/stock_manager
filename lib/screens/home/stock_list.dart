import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/providers/stocks_provider.dart';
import 'package:stock_manager/screens/operation/add_stock.dart';
import 'package:stock_manager/screens/operation/stock_detail.dart';
import 'package:stock_manager/services/sqflite_service.dart';
import 'package:stock_manager/widgets/admin_stock_card.dart';
import 'package:stock_manager/widgets/staff_stock_card.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  final ScrollController _scrollController = ScrollController();
  late Future<List<Item>> _itemsFuture;

  SqfliteService db = SqfliteService();

  @override
  void initState() {
    super.initState();
    _itemsFuture = db.getAllItems('stocks');

    _scrollController.addListener(_onScroll);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
          _searchController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        final stocksManager = context.read<StocksManager>();
        if (!stocksManager.isLoading &&
            stocksManager.currentPage < stocksManager.totalPages) {
          await stocksManager.loadMoreStocks();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context, listen: true);
    final stocksManager = Provider.of<StocksManager>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 88, bottom: 8),
                  child: TweenAnimationBuilder<int>(
                    tween: IntTween(
                        begin: stocksManager.totalStock == 0
                            ? 0
                            : stocksManager.totalStock,
                        end: stocksManager.totalStock),
                    duration: const Duration(milliseconds: 2000),
                    builder: (context, value, child) {
                      return Text(
                        '$value items in stock',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<StocksManager>(
                      builder: (context, stocksManager, _) {
                    final items = stocksManager.stocks;
                    if (stocksManager.isLoading && items.isEmpty) {
                      return const Center(
                        child: Text('Loading...'),
                      );
                    }
                    if (items.isEmpty) {
                      return const Center(
                        child: Text('No Items Yet'),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 72),
                      itemCount:
                          items.length + (stocksManager.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            ),
                          );
                        }
                        return authManager.role == 'admin'
                            ? AdminStockCard(
                                item: items[index],
                                clearFocus: () {
                                  _focusNode.unfocus();
                                  _searchController.clear();
                                },
                              )
                            : StaffStockCard(
                                item: items[index],
                                clearFoucs: () {
                                  _focusNode.unfocus();
                                  _searchController.clear();
                                },
                              );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) {
                setState(() {
                  _showSuggestions = value.isNotEmpty;
                  _itemsFuture = db.getAllItems('stocks', searchTerm: value);
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _showSuggestions = false;
                          });
                        },
                      )
                    : null,
                hintText: 'Search for items...',
                hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ),
          if (_showSuggestions)
            Positioned(
              left: 0,
              right: 0,
              top: 88,
              child: FutureBuilder<List<Item>>(
                future: _itemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
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
                      margin: const EdgeInsets.symmetric(horizontal: 18),
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
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: items[index].image,
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
                            title: Text(items[index].name),
                            subtitle: Text('Count: ${items[index].count}'),
                            onTap: () {
                              //Navigate to detail screen
                              _focusNode.unfocus();
                              _searchController.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StockItemDetail(item: items[index]),
                                ),
                              );
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
      floatingActionButton: authManager.role != 'admin'
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNewStock()),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
