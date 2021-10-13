import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './bar_chart.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  // const Chart({Key? key}) : super(key: key);
  final List<Transaction> recentTransactions;

  //contructor
  Chart(this.recentTransactions);

  //create 7 bars -> transaction grouped by day
  List<Map<String, Object>> get groupedTransactionValues {
    //7 bars ncluding today and 6 previous days
    //generate length = 7 (7 days)  (index) = 0-6 receive from length (7)
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      //for loop -> allow to repeat code multiple times
      //use for loop to sum amount
      //get total amount on a given weekday
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      //to check if it works!
      // print(DateFormat.E().format(weekday));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekday).substring(0, 2),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  //calculate max spending
  double get totalSpending {
    //fold() allow to change a list to another type
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    //to check if it works!
    // print(groupedTransactionValues);
    return
        // height: MediaQuery.of(context).size.height * 0.3,
        Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight, //to make a fix child width
              child: BarChart(
                  (data['day'] as String),
                  (data['amount'] as double),
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
