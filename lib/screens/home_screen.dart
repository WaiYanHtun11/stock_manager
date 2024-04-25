import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/screens/home_screen/refill_list.dart';
import 'package:stock_manager/screens/home_screen/remove_list.dart';
import 'package:stock_manager/screens/home_screen/stock_list.dart';

import '../icons/nav_icons_icons.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

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
      title: 'Remove',
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
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Manager'),
        actions: [
          Badge(
            backgroundColor: Colors.deepOrangeAccent,
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.notifications_active,color: Colors.deepOrangeAccent),
              onPressed: () {  },
            ),
          ),
        ],
      ),
      body:screens[currentIndex],
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
    );
  }
}
