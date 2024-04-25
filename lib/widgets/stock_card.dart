import 'package:flutter/material.dart';
const List<String> actions = ['Delete','Update'];
const Map<String,IconData> icons = {
  'Delete': Icons.delete,
  'Update': Icons.update
};

class StockCard extends StatelessWidget {
  const StockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: ListTile(
          leading: Image.asset('assets/images/stock.png'),
          title: const Text('Stock Item...'),
          subtitle: const Text('5 Items at Container 3................'),
          trailing: PopupMenuButton<String>(
            surfaceTintColor: Colors.white,
            elevation: 10,
            itemBuilder: (BuildContext context) => actions.map(
                (String a) => PopupMenuItem<String>(
                    child: ListTile(
                      leading: Icon(icons[a]),
                      title: Text(a),
                    )
                )
            ).toList(),
          ),
        ),
      ),
    );
  }
}
