import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  // const BarChart({Key? key}) : super(key: key);
  //3 properties I need
  final String label;
  final double spending;
  final double percentSpending;

  //create contructor
  BarChart(this.label, this.spending, this.percentSpending);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          //FittedBox will force its child into an available space
          Container(
            child: FittedBox(child: Text('\$${spending.toStringAsFixed(0)}')),
            height: constraints.maxHeight * 0.15,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            //Stack() allow you to place element on top (overlapping) of each other
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentSpending,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            child: FittedBox(
                child: Text(
                    label)), // FittedBox to make sure that texts are fitted in box
            height: constraints.maxHeight * 0.15,
          )
        ],
      );
    });
  }
}
