import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
//create contructor to receive data from parent class
  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return
        // height:
        //     600, //to fix yellow-black error about scrolling (have to fit a screen)
        //responsive height
        // height: MediaQuery.of(context).size.height * 0.6, //* 1 = 100%
        transactions.isEmpty
            ? LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: <Widget>[
                    Text(
                      'No transactions.....',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    //add a box with specific size | give spaces btw text and image
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              })
            : ListView.builder(
                //.builder = only load what is visible
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        //FittedBox will not let to have 2 paragrapgh
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text(
                                '\$${transactions[index].amount.toStringAsFixed(2)}'),
                          ),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMd().format(transactions[index].date),
                        // style: Theme.of(context).textTheme.caption,
                      ),
                      //delete button
                      trailing: MediaQuery.of(context).size.width > 460
                          ? TextButton.icon(
                              icon: Icon(Icons.delete),
                              label: Text('delete'),
                              onPressed: () =>
                                  deleteTransaction(transactions[index].id),
                              style: TextButton.styleFrom(
                                  primary: Theme.of(context).errorColor),
                            )
                          : IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () => deleteTransaction(
                                  transactions[index]
                                      .id), //pass id to delete function
                            ),
                    ),
                  );
                  // return Card(
                  //   child: Row(
                  //     children: <Widget>[
                  //       Container(
                  //         margin: EdgeInsets.symmetric(
                  //           vertical: 10,
                  //           horizontal: 15,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //               color: Theme.of(context).primaryColor, width: 1),
                  //         ),
                  //         padding: EdgeInsets.all(10),
                  //         child: Text(
                  //           '\$ ${transactions[index].amount.toStringAsFixed(2)}', // 'A: ' + tx.amount.toString(), with 2 digits
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .headline6, //use TextTheme defied in main.dart
                  //         ),
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           Text(
                  //             transactions[index].title,
                  //             style: TextStyle(
                  //                 fontSize: 16,
                  //                 color: Theme.of(context).primaryColor,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //           //https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
                  //           Text(
                  //             DateFormat('dd-MMM-yyyy hh:mm aaa')
                  //                 .format(transactions[index].date),
                  //             style: TextStyle(
                  //               color: Colors.blueGrey,
                  //             ),
                  //           )
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // );
                },
                itemCount: transactions
                    .length, //define how many items should be built.

                //Now, the card count the number of list items so, we comment children:
                // children: transactions.map((tx) {}).toList(),
                //and we can replace tx with transactions = overall transactions
              );
  }
}
