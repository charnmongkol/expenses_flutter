import 'dart:io'; //to find out which platform is running

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  // const NewTransaction({Key? key}) : super(key: key);

  final Function addTx;

//create final property and pass it to contructor
//this can receive private method from private class (user_transaction)
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
//create property to store selected date
  DateTime _selectedDate = DateTime.now();

//when user submit transaction
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enterTitle = _titleController.text;
    final enterAmount = double.parse(_amountController.text);

    //eazy validation
    if (enterTitle.isEmpty || enterAmount <= 0) {
      return; //if condition = true, stop below function
    }

    //widget. let us access property of this class (can only use in State class)
    widget.addTx(enterTitle, enterAmount, _selectedDate);

    //close modal after job done
    Navigator.of(context).pop();
  }

  //show date picker
  void _presentDatePicker() {
    //rifht context = class property context
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021), //0.00 am 1st January 2021
      lastDate: DateTime.now(),
      //Dart-> Future function -> will execute
      //HTTP request that you have to wait for the response from the sever
      //here, we wait user to pick date because we don't know when the user pick date and click ok.
      //then(); aloow us to provide the function which is executed after user pick a date
    ).then((pickedDate) {
      //if user click cancle
      if (pickedDate == null) {
        return;
      }
      //setState will tell Dart or Flutter
      //that the stateful widget has updated and build(BuildContext context) will run again
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                // onChanged: (value) {
                //   titleInput = value;
                // },
                controller: _titleController,
                onSubmitted: (_) => _submitData,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (value) => amountInput = value,
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData,
              ),
              //Date Picker Button
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                          'Picked Date: ${DateFormat('EEE, MMM d, ' 'yyyy').format(_selectedDate).toString()}'
                          // _selectedDate == null
                          //     ? 'No Date Chosen!'
                          //     : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!).toString()}',
                          ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text('pick date'),
                            onPressed: _presentDatePicker,
                          )
                        : TextButton(
                            child: Text('pick date'),
                            style: TextButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _presentDatePicker,
                          )
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Add Transaction'),
                      onPressed: _submitData,
                    )
                  : ElevatedButton(
                      child: Text('Add Transaction'),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context)
                            .primaryColor, //background color of ElevatedButton
                        //onPrimary: Colors.white, //text color of ElevatedButton
                        textStyle: Theme.of(context)
                            .textTheme
                            .button, //Text color derived from theme
                        onSurface: Colors.redAccent,
                      ),
                      onPressed: _submitData
                      // print(titleInput);
                      // print(amountInput);
                      //it is a Function property
                      //double.parse will change string to double.
                      )
            ],
          ),
        ),
      ),
    );
  }
}
