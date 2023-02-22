import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Widgets/new_transaction.dart';
import 'package:flutter_complete_guide/Widgets/transaction_list.dart';
import 'Widgets/transaction_list.dart';
import './models/transaction.dart';
import 'Widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        //sets color theme of app
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(
                secondary: Colors.amber), //Theme data primary and secondary

        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            button: TextStyle(color: Colors.white)),

        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String titleInput;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // )
  ];
  bool _showChart = false;

//make a list of transaction getter recent trans
//return the user tx if the date is after 7 (within the week)
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList(); //makes a list instead of interable
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

//starts process of adding a new tx
  void _startAddNewTransaction(BuildContext ctx) {
    //takes context from buildcontext below
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          //builder takes widget
          return GestureDetector(
            //detects gesture
            onTap: () {}, //when tapping on sheet avoid it getting closed
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior
                .opaque, //catch tap event and makes sure it runs okay
          );
        });
  }

 List  <Widget> _buildLanscapeContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget,) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Switch.adaptive(
            //this adds a switch that can be toggled (adaptive will make ios look like ios)
            value: _showChart, //reflects what user chose on switch (on/off)
            onChanged: (val) {
              //val is generic and flutter auto assigns (in this case bool)
              setState(() {
                //change state of app and puts show chart into value
                _showChart = val;
              });
            })
      ],
    ),_showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget];
  }

  List<Widget> _buildProtraitContent( //list of widgets
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        // only execute next container if not in landscape mode
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3, //lesson 121 turn app bar into variable to deduct appbar from height, also deduct status bar on top of screen using the padding.top
        child: Chart(_recentTransactions), //uses chart widget
      ),
      txListWidget
    ];
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere(
          (tx) => tx.id == id); //if ids match then remove this element
      //remove where removes element from a list
    });
  }

PreferredSizeWidget _buildAppBar(){
  return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, //makes row take minimum size
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            //appbar variable
            title: Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ) //sets icon putton with + sign (add)
            ],
          );
}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(
        context); //turns mediaquery into object so it doesnt need to rebuild it constantly (better for performance)
    final isLandscape = mediaQuery.orientation ==
        Orientation.landscape; //checks if orientation is in landscape
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7, //takes 60% of screen
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        //store in variable since we will use this code twice
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLanscapeContent(mediaQuery, appBar, txListWidget,), //execute _buildLandscapeContent() if device is in landscape mode
            if (!isLandscape)
              ..._buildProtraitContent(mediaQuery, appBar, txListWidget,), //three dots lesson 147       
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerFloat, //sets location for button
            floatingActionButton: Platform
                    .isIOS //if platform is ios render empty container otherwise put floating button
                ? Container() //empty container (run if on ios)
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(
                        context), //taking context from build
                  ), //adds floating button on bottom
          );
  }
}
