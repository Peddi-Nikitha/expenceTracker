import 'package:flutter/foundation.dart';

class Expense {
  final double amount;
  final DateTime date;
  final String description;

  Expense({
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Expense.fromMap(Map<dynamic, dynamic> map) {
    return Expense(
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'],
    );
  }
}
