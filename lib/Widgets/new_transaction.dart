// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //stateful allows the transactions to be saved
  final Function addTx;

  NewTransaction(this.addTx) ;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      //doesnt allow empty field
      return;
    }
    final enternedTitle = _titleController.text;
    final enteredAmount =
        double.parse(_amountController.text); //double.parse turns into decimal

    if (enternedTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; //returning does not execute addTx
    } // doesnt allow no title or amount less than 0 or negative or no date

    widget.addTx(
      enternedTitle,
      enteredAmount,
      _selectedDate,
    );
    //adds transactions entered

    Navigator.of(context).pop(); //closes top most screen (modelsheet)
  }

  void _presentDatePicker() {
    //allows you to pick date lecture 112
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      //then provides function once future resolves a value
      if (pickedDate == null) {
        //if there is no date return nothing
        return;
      }
      setState(() {
        //change to set state so UI updates after new date
        _selectedDate = pickedDate; //else the date selected is now picked date
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //allows new transcation to be scrollable
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                10, //allows you to get value of bottom of screen to size dynamically
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                // titleInput = val;
                //},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number, //makes keyboard numbers
                onSubmitted: (_) => _submitData(), //underscor bypasses argument

                //onChanged: (val) => amountInput = val,
              ), //allows user to input text
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}', //string interpolration
                      ),
                    ), //if date is null put no date else format the date
                   AdaptiveFlatButton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed:
                    _submitData, //adds transations straight from return/enter button
              )
            ],
          ),
        ),
      ),
    );
  }
}
