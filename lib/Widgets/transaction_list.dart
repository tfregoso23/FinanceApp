import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/transaction.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction; //allows us to use delete funtion from main

  TransactionList(this.transactions,
      this.deleteTransaction); //adds it as an argument so u can delete

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context)
                      .textTheme
                      .headline6, //uses headline 6 theme
                ),
                const SizedBox(
                  //empty box giving space between image and title
                  height: 10,
                ),
                Container(
                    //We wrap in a container to make image fit
                    height: constraints.maxHeight * 0.6, //so image can fit
                    child: Image.asset(
                      'assets/images/waiting1.png', //adds picture (use path)
                      fit: BoxFit.cover, //fits image
                    )),
              ],
            );
          }))
        //run this if transasctions aren't happy
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(transaction: transactions[index], deleteTransaction: deleteTransaction);
            },
            itemCount:
                transactions.length, //number of items in transactions list
          );
  }
}

