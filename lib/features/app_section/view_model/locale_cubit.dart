import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<String> {
  LocaleCubit() : super('en');

  void toggleLanguage() {
    if (state == 'en') {
      emit('ar');
    } else {
      emit('en');
    }
  }
}
