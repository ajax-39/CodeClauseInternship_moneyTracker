import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  double totalSpending = 0.0;

  Chart(this.recentTransactions, {super.key}) {
    totalSpending =
        recentTransactions.fold(0.0, (sum, txn) => sum + txn.txnAmount);
  }

  List<Map<String, Object>> get groupedTransactionValues {
    final today = DateTime.now();
    List<double> weekSums = List<double>.filled(7, 0);

    for (Transaction txn in recentTransactions) {
      weekSums[txn.txnDateTime.weekday - 1] += txn.txnAmount;
    }

    return List.generate(7, (index) {
      final dayOfPastWeek = today.subtract(
        Duration(days: index),
      );

      return {
        'day': DateFormat('E').format(dayOfPastWeek)[0],
        'amount': weekSums[dayOfPastWeek.weekday - 1],
      };
    }).reversed.toList();
  }

  Color _getColor(double amount) {
    // Example of generating different colors based on spending amount
    if (amount <= 100) {
      return Colors.green;
    } else if (amount <= 200) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((value) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: value['day'] as String,
                spendingAmount: value['amount'] as double,
                spendingPctOfTotal: totalSpending == 0.0
                    ? 0.0
                    : (value['amount'] as double) / totalSpending,
                barColor: _getColor(value['amount'] as double),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
