import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label; //text weeekday
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar(
      this.label, this.spendingAmount, this.spendingPctOfTotal); //constructors

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(  //lesson 123 constraints defines how much space a certain widegt may take
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  //forces child into fitted space , so if text is too big it shrinks it (lecture 106)
                  child: Text(
                      '\$${spendingAmount.toStringAsFixed(0)}') //Text with dollar signs rounded
                  ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ), 
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  //allows you to stack items on top of eachother
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey, width: 1.0), //color of border
                      color: Color.fromRGBO(220, 220, 220,
                          1), //background color of container makes grey
                      borderRadius: BorderRadius.circular(
                          10), //border radius of 10 pixels
                    ),
                  ),
                  FractionallySizedBox(
                    //stack second container on top of one above (showing the pct bar)
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
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
            Container(height: constraints.maxHeight * 0.15,
            child: FittedBox(child: Text(label))),
          ],
        );
      },
    );
  }
}
