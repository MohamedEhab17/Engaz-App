class PopupFormState {
  final Map<String, dynamic> values;

  PopupFormState({required this.values});

  PopupFormState copyWith({Map<String, dynamic>? values}) {
    return PopupFormState(
      values: values ?? this.values,
    );
  }
}
