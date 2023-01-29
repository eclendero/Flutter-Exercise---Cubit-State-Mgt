import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<bool> {
  CategoryCubit() : super(true);

  //Changes the sign (+/-) in the amount textfield
  void toggle() => emit(!state);
}
