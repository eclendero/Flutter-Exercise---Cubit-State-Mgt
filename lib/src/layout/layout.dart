import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/category_cubit.dart';
import '../cubit/text_validation_cubit.dart';
import '../cubit/transactions_cubit.dart';
import '../cubit/amount_validation_cubit.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final transactionController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF333F50),
        //Allows the screen to be scrollable when the keyboard appears
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            //margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            // height: viewHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                displayUpper(),
                createSpace(35),
                displayLower(),
                // createSpace(10), //Needed to make the scrollable page in view
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayUpper() {
    return BlocBuilder<TransactionsCubit, Map>(builder: (context, details) {
      double total = details['income'] + details['expenses'];
      String sign = total.isNegative ? '-' : '';

      return Column(
        children: [
          createText(
              'EXPENSE TRACKER', 25, true, 0xFFFFFFFF), //'' is default position
          createSpace(20),
          //Displays Balance
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(72, 166, 154, 0.63),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 40, 50, 63),
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                createText('BALANCE', 25, false, 0xFFFFFFFF),
                //\u20B1 is Unicode for peso
                createText('$sign \u20B1 ${formatNumber(total.abs())}', 25,
                    false, 0xFFFFFFFF),
              ],
            ),
          ),
          createSpace(30),
          //Displays Total income/expenses
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              showTotal('INCOME', details['income']),
              showTotal('EXPENSES', details['expenses']),
            ],
          ),
          createSpace(35),
          //Displays the History section
          displayTransactions(),
        ],
      );
    });
  }

  //Formats the numbers with commas and to 2 decimal places
  String formatNumber(double number) {
    final formatter = NumberFormat("#,##0.00");
    return formatter.format(number);
  }

  Widget displayTransactions() {
    return BlocBuilder<TransactionsCubit, Map>(builder: (context, details) {
      return Stack(
        children: [
          Column(
            children: [
              createSpace(15), //Allows the History header to overlap
              Container(
                padding: const EdgeInsets.fromLTRB(12, 25, 12, 5),
                //height needs to be set for Listbuilder
                //30 is the top margin, 5 is the bottom margin
                height: details['transactions'].isEmpty
                    ? 35 + 55.5
                    : 35 + (55.5 * (details['transactions'].length).toDouble()),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFF456969),
                  ),
                ),
                constraints: const BoxConstraints(maxHeight: 185),
                child: createHistory(details['transactions']),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: const Color(0xFF333F50),
            child: createText('Transactions', 23, false, 0xFFFFFFFF),
          ),
        ],
      );
    });
  }

  //Creates an empty contaner with set margin
  Widget createSpace(double height) {
    return Container(
      height: height,
    );
  }

  //Creates text
  Widget createText(
    String text,
    double textSize,
    bool isFontBold,
    int fontColor,
  ) {
    return Text(
      text,
      style: TextStyle(
        fontStyle: (text == 'No transaction to show') ? FontStyle.italic : null,
        fontSize: textSize,
        fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal,
        color: Color(fontColor), //getColor(),
      ),
    );
  }

  //Displays the total income/expenses
  Widget showTotal(String category, double amount) {
    return Column(
      children: [
        createText('TOTAL $category', 20, false, 0xFFFFFFFF),
        createText('\u20B1 ${formatNumber(amount.abs())}', 20, false,
            category == "INCOME" ? 0xFF339933 : 0xFFFF4343),
      ],
    );
  }

  //Creates content of History section
  Widget createHistory(List transactions) {
    if (transactions.isEmpty) {
      return Column(
        children: [
          createSpace(5),
          createText('No transaction to show', 18, false, 0xFF406374),
        ],
      );
    } else {
      // return BlocBuilder<TransactionsCubit, List>(builder: (context, state) {
      return ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          Map entry = transactions[index];
          return Column(
            children: [
              // createSpace(30),
              createEntry(entry['transaction'], (entry['amount']), index),
              createSpace(5),
            ],
          );
        },
      );
      // });
    }
  }

  Widget createEntry(String transaction, double amount, int index) {
    String sign = amount.isNegative ? '-' : '+';
    //standardizes to two decimal place

    return BlocBuilder<TransactionsCubit, Map>(builder: (context, details) {
      return Container(
        color: const Color.fromRGBO(42, 40, 43, 0.69),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Displays the transaction
            createText(transaction, 16, false, 0xFFFFFFFF),
            Row(
              children: [
                //Displays the amount
                createText('$sign \u20B1 ${formatNumber(amount.abs())}', 18,
                    false, (sign == '-') ? 0xFFFF4343 : 0xFF339933),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF304B59),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<TransactionsCubit>(context).remove(index);
                    },
                    child: displayIcon(Icons.clear_rounded, 0xFFADB880, 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  //Displays the sign in the amount text field
  Widget displayIcon(IconData icon, int color, double size) {
    return Icon(
      icon,
      color: Color(color),
      size: size,
    );
  }

  Widget displayLower() {
    return BlocBuilder<CategoryCubit, bool>(builder: (context, state) {
      return Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (!state) {
                    BlocProvider.of<CategoryCubit>(context).toggle();
                  }
                },
                child: createText(
                    'Income', 18, false, state ? 0xFFFFFFFF : 0xFF406374),
              ),
              displayIcon(
                Icons.arrow_upward,
                state ? 0xFF339933 : 0xFF406374,
                18,
              ),
              Container(margin: const EdgeInsets.only(right: 20)),
              InkWell(
                onTap: () {
                  // CategoryState.toggle();
                  if (state) {
                    BlocProvider.of<CategoryCubit>(context).toggle();
                  }
                },
                child: createText(
                    'Expense', 18, false, state ? 0xFF406374 : 0xFFFFFFFF),
              ),
              displayIcon(
                Icons.arrow_downward,
                state ? 0xFF406374 : 0xFFFF4343,
                18,
              )
            ],
          ),
          const Divider(
            height: 10,
            thickness: 1.25,
            color: Color(0xFF456969),
          ),
          createForm(),
        ],
      );
    });
  }

  Widget createForm() {
    return Column(
      children: [
        createSpace(10),
        Align(
          alignment: Alignment.centerLeft,
          child: createText('New Transaction', 18, false, 0xFFFFFFFF),
        ),
        createSpace(5),
        createTextField(),
        createSpace(10),
        Align(
          alignment: Alignment.centerLeft,
          child: createText('Amount', 18, false, 0xFFFFFFFF),
        ),
        createSpace(5),
        createNumberField(),
        createSpace(20),
        createButton(),
      ],
    );
  }

  Widget createTextField() {
    return BlocBuilder<TextValidationCubit, Map>(
        builder: (context, textValidation) {
      return TextFormField(
        controller: transactionController,
        //Allows the errorText to be updated
        onChanged: (newText) =>
            BlocProvider.of<TextValidationCubit>(context).validateText(newText),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(42, 104, 111, 0.25),
          hintText: 'Enter transaction', //text,
          hintStyle: const TextStyle(fontSize: 18, color: Color(0xFF406374)),
          border: InputBorder.none, //Removes the default bottom border
          //Creates a bottom border when field is clicked
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(42, 104, 111, 1),
              width: 1.5,
            ),
          ),
          errorText: (textValidation['Validity'] == 'Empty')
              ? 'Please enter a transaction'
              : null,
          errorStyle: const TextStyle(fontSize: 14, color: Color(0xFFFF4343)),
        ),
        style: (const TextStyle(fontSize: 18, color: Color(0xFFFFFFFF))),
      );
    });
  }

  Widget createNumberField() {
    return BlocBuilder<AmountValidationCubit, Map>(
      builder: (context, amountValidation) {
        return BlocBuilder<CategoryCubit, bool>(builder: (context, isIncome) {
          return TextFormField(
            controller: amountController,
            //Allows the errorText to be updated
            onChanged: (newText) =>
                BlocProvider.of<AmountValidationCubit>(context)
                    .validateAmount(newText),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(42, 104, 111, 0.25),
              //Compared to prefix with a Text child, this widget shows the icon even when not in focus
              prefixIcon: displayIcon(
                  isIncome ? Icons.add : Icons.remove, 0xFFFFFFFF, 12),
              hintText: 'Enter amount',
              hintStyle:
                  const TextStyle(fontSize: 18, color: Color(0xFF406374)),
              border: InputBorder.none, //Removes the default bottom border
              //Creates a bottom border when field is clicked
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(42, 104, 111, 1),
                  width: 1.5,
                ),
              ),
              errorText: (amountValidation['Validity'] == 'Empty')
                  ? 'Please enter an amount'
                  : (amountValidation['Validity'] == 'Invalid')
                      ? 'Amount should only have one decimal point'
                      : null,
              errorStyle:
                  const TextStyle(fontSize: 14, color: Color(0xFFFF4343)),
            ),
            style: (const TextStyle(fontSize: 18, color: Color(0xFFFFFFFF))),
          );
        });
      },
    );
  }

  Widget createButton() {
    return BlocBuilder<AmountValidationCubit, Map>(
        builder: (context, amountValidation) {
      return BlocBuilder<TextValidationCubit, Map>(
          builder: (context, textValidation) {
        return BlocBuilder<CategoryCubit, bool>(
          builder: (context, isIncome) {
            return Container(
              alignment: Alignment.center,
              color: const Color(0xFF652B91),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: InkWell(
                onTap: () {
                  //For better code readability
                  bool isValidAmount = amountValidation['Validity'] == 'Valid';
                  bool isValidText = textValidation['Validity'] == 'Valid';

                  if (isValidAmount && isValidText) {
                    //Clears textfield
                    transactionController.clear();
                    amountController.clear();
                    //Stores inputs
                    BlocProvider.of<TransactionsCubit>(context).store(
                        textValidation['Text'],
                        '$isIncome${amountValidation['Text']}');
                    //Resets states
                    BlocProvider.of<AmountValidationCubit>(context)
                        .resetAmount();
                    BlocProvider.of<TextValidationCubit>(context).resetText();
                  } else {
                    (!isValidText)
                        ? BlocProvider.of<TextValidationCubit>(context)
                            .validateText(
                                '') //'Empty'; makes error message appear
                        : null;
                    (amountValidation['Validity'] == '')
                        //emits 'Empty'; makes error message appear
                        //State does not change when an invalid amount is submitted
                        ? BlocProvider.of<AmountValidationCubit>(context)
                            .validateAmount('')
                        : null;
                  }
                },
                child: createText('Add Transaction', 18, false, 0xFFFFFFFF),
              ),
            );
          },
        );
      });
    });
  }
}
