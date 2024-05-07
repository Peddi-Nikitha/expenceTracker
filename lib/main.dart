import 'package:exptrack_app/data/repositories/expense_repository.dart';
import 'package:exptrack_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
 final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('expenses');
  await Hive.openBox('balance');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExpenseRepository>(
          create: (_) => ExpenseRepository(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        
        home: HomeScreen(),
      ),
    );
  }
}
