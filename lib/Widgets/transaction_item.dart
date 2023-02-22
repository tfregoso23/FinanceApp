import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';


class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      //card makes each transaction  its own card
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          //circleavatar round widget holds content
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                //allows text to fit inside cirles
                child: Text(
                    '\$${transaction.amount.toStringAsFixed(2)}') //amount at current index
                ),
          ),
        ),
        title: Text(
            //titles the current transactions
            transaction.title,
            style: Theme.of(context).textTheme.headline6),
        subtitle: Text(
          //goes under title
          DateFormat.yMMMd().format(transaction
              .date), //ouputs date in readable format
        ),
        trailing: MediaQuery.of(context).size.width > 460 //trailing is what comes after.... only run this code if there is at least 460 pixels of space
            ? FlatButton.icon(
                icon: const Icon(Icons.delete), //trash can icon
                textColor: Theme.of(context).errorColor,
                label: const Text('Delete') ,
                onPressed: () => deleteTransaction(transaction 
                    .id),
              )
            : IconButton(
                icon: const Icon(Icons.delete), //trash can icon
                color: Theme.of(context)
                    .errorColor, //error color is red by default
                onPressed: () => deleteTransaction(transaction
                    .id), //deletes current index id
              ),
      ),
    );
  }
}
