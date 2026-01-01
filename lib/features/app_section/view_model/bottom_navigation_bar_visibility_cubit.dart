import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBarVisibilityCubit extends Cubit<bool> {
  BottomNavigationBarVisibilityCubit() : super(true); //when open be visible

  void show()=>emit(true);
  void hide()=>emit(false);
}
