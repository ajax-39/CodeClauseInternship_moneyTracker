import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;
  final Color barColor;

  const ChartBar({
    super.key,
    required this.label,
    required this.spendingAmount,
    required this.spendingPctOfTotal,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '₹${spendingAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.6,
            width: 20, // Width of the bar
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
