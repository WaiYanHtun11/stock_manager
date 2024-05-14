import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/providers/out_of_stock.dart';
import 'package:stock_manager/screens/home/refill_list.dart';
import 'package:stock_manager/screens/home/remove_list.dart';
import 'package:stock_manager/screens/home/report_list.dart';
import 'package:stock_manager/screens/home/stock_list.dart';
import 'package:stock_manager/screens/home/out_of_stock_screen.dart';
import 'package:stock_manager/services/database_service.dart';

import '../icons/nav_icons_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final DatabaseService _databaseService = DatabaseService();
  bool _initialized = false;

  List<TabItem> items = const [
    TabItem(
      icon: NavIcons.th_list,
      title: 'Stocks',
    ),
    TabItem(
      icon: NavIcons.plus_squared,
      title: 'Refill',
    ),
    TabItem(
      icon: NavIcons.minus_squared,
      title: 'Sale',
    ),
    TabItem(
      icon: NavIcons.chart_bar,
      title: 'Report',
    ),
  ];

  List<Widget> screens = [
    const StockList(),
    const RefillList(),
    const RemoveList(),
    const ReportList(),
  ];

  Future<void> _initializeApp() async {
    // Simulate any initialization tasks here, such as fetching data
    await _databaseService.syncData();
    setState(() {
      _initialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return _initialized
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Stock Manager'),
              actions: [
                Consumer<OutofStockManager>(
                    builder: (context, outofStockManager, _) {
                  final isOutofStock = outofStockManager.isOutofStock;
                  return IconButton(
                    icon: Icon(
                        isOutofStock
                            ? Icons.notifications_active
                            : Icons.notifications,
                        color: isOutofStock
                            ? Colors.deepOrangeAccent
                            : Colors.blueGrey),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OutofStockScreen()));
                    },
                  );
                }),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Provider.of<AuthManager>(context, listen: false).signOut();
                  },
                )
              ],
            ),
            body: screens[currentIndex],
            bottomNavigationBar: BottomBarFloating(
              items: items,
              backgroundColor: Colors.white,
              color: Colors.black,
              colorSelected: Colors.deepOrangeAccent,
              indexSelected: currentIndex,
              onTap: (int index) => setState(() {
                currentIndex = index;
              }),
            ),
          )
        : const Scaffold(body: Center(child: Text('Initializing Data...')));
  }
}
