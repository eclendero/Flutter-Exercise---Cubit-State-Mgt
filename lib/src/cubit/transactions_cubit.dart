import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsCubit extends Cubit<Map<String, dynamic>> {
  TransactionsCubit()
      : super({'transactions': [], 'income': 0.00, 'expenses': 0.00});

  void store(String transaction, String amount) {
    late double signedAmount;
    late String newAmount;
    late double newIncome;
    late double newExpenses;

    if (amount.contains('false')) {
      newAmount = amount.replaceAll(RegExp(r'false'), '-');
      signedAmount = double.parse(newAmount);
    } else {
      newAmount = amount.replaceAll(RegExp(r'true'), '');
      signedAmount = double.parse(newAmount);
    }

    if (signedAmount.isNegative) {
      //newAmount will be added to expenses
      newExpenses = state['expenses'] + signedAmount;
      newIncome = state['income'];
    } else {
      //newAmount will be added to income
      newIncome = state['income'] + signedAmount;
      newExpenses = state['expenses'];
    }

    Map<String, dynamic> entry = {
      "transaction": transaction,
      "amount": signedAmount,
    };

    //Add entry to existing list
    List<Map> newTransactions = [...state['transactions'], entry];
    Map<String, dynamic> details = {
      'transactions': newTransactions,
      'income': newIncome,
      'expenses': newExpenses,
    };
    emit(details);
  }

  void remove(int index) {
    List transactions = state['transactions'];
    double entryAmount = transactions[index]['amount'];
    double newExpenses = state['expenses'];
    double newIncome = state['income'];
    transactions.removeAt(index);

    if (entryAmount.isNegative) {
      newExpenses = state['expenses'] - entryAmount;
    } else {
      newIncome = state['income'] - entryAmount;
    }

    Map<String, dynamic> details = {
      'transactions': transactions,
      'income': newIncome,
      'expenses': newExpenses,
    };

    emit(details);
  }
}

class History {
  late String transaction;
  late double amount;

  History({required this.transaction, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      "transaction": transaction,
      "amount": amount,
    };
  }
}
