import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Widgets/chart_bar.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  // This yields a list with items map
  //In map we will have keys with strings and objects
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      //this generates the data
      // Takes datetime now and subtracts index to get each day
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        //for loop to dtermine value
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0,
            1), //starts at first character and ends after next (makes it single letter)
        'amount': totalSum
      }; //DateFormat.E gives first letter of week day
    }).reversed.toList(); //7 for 7 days. Index executes function 7 times
  }

  double get totalSpending {
    //getter to gte percent (lecture 105)
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        //elevation gives shadow insets give margin
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10), //spacing around bars
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, //spaces chart bars around
            children: groupedTransactionValues.map((data) {
              return Flexible( //using this so that if a big amount is entered, font size changes to fit
                fit: FlexFit.tight, //squeezes value into size
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  //only calculate if non zero
                  totalSpending == 0.0 ? 0.0:  (data['amount'] as double) / totalSpending, //use as souble to be able to divide
                ),
              ); 
            }).toList(),
          ),
        ),
    );
  }
}
