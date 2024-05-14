import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/firebase_options.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/providers/daily_provider.dart';
import 'package:stock_manager/providers/out_of_stock.dart';
import 'package:stock_manager/providers/reports_provider.dart';
import 'package:stock_manager/providers/stocks_provider.dart';
import 'package:stock_manager/screens/authentication/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Define your providers here
        ChangeNotifierProvider(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => StocksManager()),
        ChangeNotifierProvider(create: (_) => ReportsManager()),
        ChangeNotifierProvider(create: (_) => DailyManager()),
        ChangeNotifierProvider(create: (_) => OutofStockManager()),
      ],
      child: MaterialApp(
        title: 'Stock Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
          useMaterial3: true,
        ),
        home: const AuthenticationScreen(),
      ),
    );
  }
}
