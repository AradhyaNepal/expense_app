import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Expense.dart';

class ExpenseCardWidget extends StatelessWidget{
  final Expense expenseDetails;
  final Function deleteItemFunction;
  ExpenseCardWidget(this.expenseDetails,this.deleteItemFunction);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(  
        borderRadius: BorderRadius.circular(10),
            
      ),
      margin: EdgeInsets.all(5),

      child:ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              child: Text(
                  'Rs.${expenseDetails.price}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          expenseDetails.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle:Text(
          expenseDetails.description+'\n'+
          DateFormat.yMMMMEEEEd().format(expenseDetails.date),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(

              icon: Icon(Icons.delete),
              onPressed: () {
                deleteItemFunction(expenseDetails.id);
              },
        )
      )

    );
  }
}