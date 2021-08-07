import 'package:expense_app/ExpenseCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'Expense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueAccent,
      ),
      home: ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  List<Expense> expenseList = [];

  void setInitialValue() {
    //Dummy data
    if (Expense.maxId < 3) {
      expenseList.add(Expense(
          update: false,
          name: 'Dummy1',
          date: DateTime.now(),
          description: 'ABCD',
          price: 10));
      expenseList.add(Expense(
          update: false,
          name: 'Dummy2',
          date: DateTime.now(),
          description: 'ABCD',
          price: 20));
    }
  }

  void delete(int id) {
    setState(() {
      expenseList.removeWhere((element) => element.id == id);
    });
  }

  DateTime dateValue=DateTime.now();

  void openDateSelector(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        print('No date selected');
        return;
      }
      setState(() {
        dateValue = value;
      });
    });
  }
  void openModel(int index) {
    //index -1 = for new value >0 means for editing
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();


    String heading = 'Add Expense';
    String buttonText = 'Add';
    if (index > -1) {
      Expense expense = expenseList[index];
      nameController.text = expense.name;
      priceController.text = expense.price.toString();
      descriptionController.text = expense.description;
      dateValue = expense.date;
      heading = 'Edit Expense';
      buttonText = 'Edit';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(28, 64, 117, 1),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
              ),
              child: Column(
                children: [
                  Text(
                    heading,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  //date, name,description, price;
                  TextField(
                    controller: nameController,
                    decoration: new InputDecoration(
                      hintText: 'Item Name',
                    ),
                  ),

                  TextField(
                    controller: descriptionController,
                    decoration: new InputDecoration(
                      hintText: 'Item Description',
                    ),
                  ),

                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      hintText: 'Item Price',
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat.yMd().format(dateValue),
                        ),
                      ),
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                            openDateSelector();
                          },

                        child: Text(
                          'Pick Date',
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ],
                  ),

                  ElevatedButton(
                      onPressed: () {
                        //date, name,description, price;
                        String name = nameController.text;
                        String description = descriptionController.text;
                        int price = int.parse(priceController.text);
                        if (name.isEmpty || description.isEmpty || price < 1) {
                          print(
                              'Error'); // TODO:Add error message to be displayed in screen
                        } else {
                          setState(() {
                            if (index > -1) {
                              expenseList.insert(
                                  index,
                                  Expense(
                                      update: true,
                                      id: expenseList[index].id,
                                      date: dateValue,
                                      name: name,
                                      description: description,
                                      price: price));
                              expenseList.removeAt(index + 1);
                            } else {
                              expenseList.add(Expense(
                                  update: false,
                                  date: dateValue,
                                  name: name,
                                  description: description,
                                  price: price));
                            }
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(buttonText)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int getPosition(int id) {
    for (int i = 0; i < expenseList.length; i++) {
      if (expenseList[i].id == id) return id;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    setInitialValue();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openModel(-1); //for new value
          },
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
          title: Text('Expense App'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Text('Chart'),
              ),
            ),
            Expanded(
                flex: 9,
                child: ListView.builder(
                  itemCount: expenseList.length,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      child: ExpenseCardWidget(expenseList[position], delete),
                      onTap: () {
                        openModel(position);
                      },
                    );
                  },
                )),
          ],
        ));
  }
}
