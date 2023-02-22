import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

//Turns the button into a widget(used in new_transaction.dart)
//lecture 136

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;
  AdaptiveFlatButton(this.text, this.handler); //when you call this function you type in your text and what you want to happen

  @override
  Widget build(BuildContext context) {
    return  Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              text,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: handler,
                          )
                        : FlatButton(
                            textColor: Theme.of(context).colorScheme.primary,
                            onPressed: handler,
                            child: Text(
                              text,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
      
    );
  }
}