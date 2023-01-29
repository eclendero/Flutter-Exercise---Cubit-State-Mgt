import 'package:flutter_bloc/flutter_bloc.dart';

class TextValidationCubit extends Cubit<Map<String, String>> {
  TextValidationCubit() : super({'Validity': '', 'Text': ''});

  void validateText(String text) {
    if (text.isEmpty) {
      emit({'Validity': 'Empty', 'Text': text});
    } else {
      emit({'Validity': 'Valid', 'Text': text});
    }
  }

  void resetText() => emit({'Validity': '', 'Text': ''});
}
