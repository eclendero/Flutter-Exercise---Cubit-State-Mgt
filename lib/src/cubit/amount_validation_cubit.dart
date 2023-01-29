import 'package:flutter_bloc/flutter_bloc.dart';

class AmountValidationCubit extends Cubit<Map<String, String>> {
  AmountValidationCubit() : super({'Validity': '', 'Text': ''});

  void validateAmount(String text) {
    if (text.isEmpty) {
      emit({'Validity': 'Empty', 'Text': text});
    } else if ((text.split('.').length > 2)) {
      emit({'Validity': 'Invalid', 'Text': text});
    } else {
      emit({'Validity': 'Valid', 'Text': text});
    }
  }

  void resetAmount() => emit({'Validity': '', 'Text': ''});
}
