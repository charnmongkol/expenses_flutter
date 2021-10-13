import 'dart:io'; //to find out which platform is running

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import '../models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          //set text theme
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                button: TextStyle(color: Colors.white),
              )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //list of transaction objects
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: '1', title: 'new shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(id: '2', title: 'Netflix', amount: 13.55, date: DateTime.now()),
    // Transaction(id: '2', title: 'Netflix', amount: 13.55, date: DateTime.now()),
    // Transaction(id: '2', title: 'Netflix', amount: 13.55, date: DateTime.now()),
    // Transaction(id: '2', title: 'Netflix', amount: 13.55, date: DateTime.now()),
    // Transaction(id: '2', title: 'ccccc', amount: 13.55, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    //where allows you to run a function on every items in a List.
    //and if function returns true, the item is kept in a new list
    return _userTransactions.where((tx) {
      //isAfter() -> tx.date is after tx.date - 7days -> true = add to List
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList(); // where will return Iterable but we expect List here
  }

//add a method that doesn't return anything -> void
// _ = private and this is the part of _UserTransactionsState class
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  //method that happend after click add button
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          //return what in modal-> input
          return NewTransaction(_addNewTransaction);
        });
  }

  //Delete method
  void _deleteTransaction(String id) {
    //1. need to call setState() because we will re-build UI
    setState(() {
      //reach out _userTransactions to our list of Transactions
      //removeWhere will remove item where condition is matched.
      //this function get (element = transaction) of each List
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    //to check weather Landscape or potrait
    final isLanscape = mediaQuery.orientation == Orientation.landscape;
    //app bar
    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add), //Apple add icon
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expenses'),

            //add + button on appbar
            actions: <Widget>[
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add)),
            ],
          )) as PreferredSizeWidget;

    final txList = Container(
        child: TransactionList(_userTransactions, _deleteTransaction),
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7);

    final pageBody = SafeArea(
      // safearea -> avoid OS UI space -> reserve area in app
      child: SingleChildScrollView(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLanscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Chart',
                      style: Theme.of(context).textTheme.button,
                    ),
                    //toggle button/ adaptive will adjust button depending on platform (ios/andriod)
                    Switch.adaptive(
                        activeColor: Theme.of(context).accentColor,
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            //because we will update UI.
                            _showChart = val;
                          });
                        })
                  ],
                ),

              if (!isLanscape)
                Container(
                  child: Chart(_recentTransactions),
                  //available height - appbar height - status mobile bar
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.4,
                ),
              if (!isLanscape) txList,

              //if turn the toggle on ? showChart
              if (isLanscape)
                _showChart
                    ? Container(
                        child: Chart(_recentTransactions),
                        //available height - appbar height - status mobile bar
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                      )
                    : txList
            ]),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            //add floting + button
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS //if the device is IOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
