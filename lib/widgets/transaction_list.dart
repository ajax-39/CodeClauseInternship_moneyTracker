import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _allTransactions;
  final Function _deleteTransaction;

  const TransactionList(this._allTransactions, this._deleteTransaction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return _allTransactions.isEmpty
          // No Transactions
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Nothing is there",
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 22.0,
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
       
              ],
            )
          // Transactions Present
          : ListView.builder(
              itemCount: _allTransactions.length,
              itemBuilder: (context, index) {
                Transaction txn = _allTransactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3.0, vertical: 3.0),
                  child: Dismissible(
                    key: ValueKey(txn.txnId),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteTransaction(txn.txnId);
                    },
                    background: Container(
                      color: Theme.of(context).colorScheme.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 15.0),
                      child: InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: Container(
                            width: 70.0,
                            height: 50.0,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Colors.pink[700],
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '₹${txn.txnAmount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            txn.txnTitle,
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('MMMM d, y -')
                                .add_jm()
                                .format(txn.txnDateTime),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }
}
