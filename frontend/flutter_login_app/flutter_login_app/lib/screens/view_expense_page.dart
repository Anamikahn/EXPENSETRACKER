import 'package:flutter/material.dart';

class ViewExpensesPage extends StatelessWidget {
  const ViewExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample dummy data
    List<Map<String, String>> expenses = [
      {"id": "1", "name": "Food", "amount": "100"},
      {"id": "2", "name": "Travel", "amount": "200"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("View Expenses")),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final item = expenses[index];
          return ListTile(
            title: Text("${item['name']}"),
            subtitle: Text("Amount: ${item['amount']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    print("Edit ${item['id']}");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    print("Delete ${item['id']}");
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}