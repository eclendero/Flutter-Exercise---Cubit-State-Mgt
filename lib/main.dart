import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/cubit/transactions_cubit.dart';
import 'src/cubit/amount_validation_cubit.dart';
import 'src/cubit/text_validation_cubit.dart';
import 'src/cubit/category_cubit.dart';
import 'src/layout/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TransactionsCubit>(
              create: (BuildContext context) => TransactionsCubit()),
          BlocProvider<TextValidationCubit>(
              create: (BuildContext context) => TextValidationCubit()),
          BlocProvider<AmountValidationCubit>(
              create: (BuildContext context) => AmountValidationCubit()),
          BlocProvider<CategoryCubit>(
              create: (BuildContext context) => CategoryCubit()),
        ],
        child: MyHomePage(),
      ),
    );
  }
}
