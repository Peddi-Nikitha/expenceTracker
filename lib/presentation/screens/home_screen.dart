import 'package:exptrack_app/data/models/expense_model.dart';
import 'package:exptrack_app/data/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expense Tracker'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceSection(context),
              _buildExpenseSummary(context),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: _buildExpenseList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
    double balance = Provider.of<ExpenseRepository>(context).getBalance();
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(17),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showUpdateBalanceForm(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Update Balance'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseSummary(BuildContext context) {
    final Map<String, double>? summary =
        Provider.of<ExpenseRepository>(context).getExpenseSummary();

    if (summary == null || summary.isEmpty) {
      // Return a placeholder widget or handle the empty case
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Expense Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'No expense data available',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showAddExpenseForm(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      );
    }

    final double totalSummary = _calculateTotalExpensesByDay(summary);

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(17),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Expense Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${totalSummary.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showAddExpenseForm(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalExpensesByDay(Map<String, double> summary) {
    double totalSummary = 0;

    // Iterate through the summary and aggregate expenses by day
    summary.forEach((description, amount) {
      totalSummary += amount;
    });

    return totalSummary;
  }

  Widget _buildExpenseList(BuildContext context) {
    List<Expense> expenses =
        Provider.of<ExpenseRepository>(context).getExpenses();

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (BuildContext context, int index) {
        Expense expense = expenses[index];
        return Card(
          child: ListTile(
            title: Text('Amount: \$${expense.amount.toStringAsFixed(2)}'), 
            subtitle: Text('Description: ${expense.description}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditExpenseModal(context, index);
              },
            ),
          ),
        );
      },
    );
  }

  void _showUpdateBalanceForm(BuildContext context) {
    TextEditingController balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Update Balance'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: balanceController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double amount = double.parse(balanceController.text);
                Provider.of<ExpenseRepository>(context, listen: false)
                    .addBalance(amount);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExpenseForm(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Add Expense'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double amount;
                try {
                  amount = double.parse(amountController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Invalid amount'),
                  ));
                  return;
                }
                String description = descriptionController.text;

                Expense expense = Expense(
                  amount: amount,
                  date: DateTime.now(),
                  description: description,
                );

                Provider.of<ExpenseRepository>(context, listen: false)
                    .addExpense(expense);

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditExpenseModal(BuildContext context, int index) {
    Expense expense = Provider.of<ExpenseRepository>(context, listen: false)
        .getExpenses()[index];
    TextEditingController amountController =
        TextEditingController(text: expense.amount.toString());
    TextEditingController descriptionController =
        TextEditingController(text: expense.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Edit Expense'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double amount;
                try {
                  amount = double.parse(amountController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Invalid amount'),
                  ));
                  return;
                }
                String description = descriptionController.text;

                Expense editedExpense = Expense(
                  amount: amount,
                  date: expense.date,
                  description: description,
                );

                Provider.of<ExpenseRepository>(context, listen: false)
                    .editExpense(index, editedExpense);

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

