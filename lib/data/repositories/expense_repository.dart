
import 'package:exptrack_app/data/models/expense_model.dart';
import 'package:hive/hive.dart';

class ExpenseRepository {
  final Box _expenseBox;
  final Box _balanceBox;

  ExpenseRepository()
      : _expenseBox = Hive.box('expenses'),
        _balanceBox = Hive.box('balance');

  Future<void> addExpense(Expense expense) async {
    await _expenseBox.add(expense.toMap());
      await subtractBalance(expense.amount);

  }

  List<Expense> getExpenses() {
    return _expenseBox.values.map((e) => Expense.fromMap(e)).toList().cast<Expense>();
  }

  Future<void> editExpense(int index, Expense newExpense) async {
    await _expenseBox.putAt(index, newExpense.toMap());
  }

  Future<void> deleteExpense(int index) async {
    await _expenseBox.deleteAt(index);
  }

  double getBalance() {
    double balance = _balanceBox.get('balance', defaultValue: 0.0);
    return balance;
  }

  Future<void> addBalance(double amount) async {
    double currentBalance = getBalance();
    double updatedBalance = currentBalance + amount;
    await _balanceBox.put('balance', updatedBalance);
  }

  Future<void> subtractBalance(double amount) async {
    double currentBalance = getBalance();
    double updatedBalance = currentBalance - amount;
    await _balanceBox.put('balance', updatedBalance);
  }

  Map<String, double> getExpenseSummary() {
  Map<String, double> summaryMap = {};
  List<Expense> expenses = getExpenses();
  expenses.forEach((expense) {
    if (!summaryMap.containsKey(expense.description)) {
      summaryMap[expense.description] = 0;
    }
    // Adding null check before adding the expense amount to the summaryMap
    if (expense.amount != null) {
      summaryMap[expense.description] = (summaryMap[expense.description] ?? 0) + expense.amount!;
    }
  });
  return summaryMap;
}

}
