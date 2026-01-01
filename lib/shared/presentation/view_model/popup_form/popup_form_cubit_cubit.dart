import 'package:engaz_app/shared/presentation/view_model/popup_form/popup_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PopupFormCubit extends Cubit<PopupFormState> {
  PopupFormCubit() : super(PopupFormState(values: {}));

  void setValue(String key, dynamic value) {
    final newValues = Map<String, dynamic>.from(state.values);
    newValues[key] = value;
    emit(state.copyWith(values: newValues));
  }

  dynamic getValue(String key) => state.values[key];

  void reset(Map<String, dynamic> initialValues) {
    emit(PopupFormState(values: Map<String, dynamic>.from(initialValues)));
  }
}
