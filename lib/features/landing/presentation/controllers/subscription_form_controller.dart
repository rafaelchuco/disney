import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionFormState {
  const SubscriptionFormState({
    this.email = '',
    this.isSubmitting = false,
    this.successMessage,
    this.errorMessage,
  });

  final String email;
  final bool isSubmitting;
  final String? successMessage;
  final String? errorMessage;

  SubscriptionFormState copyWith({
    String? email,
    bool? isSubmitting,
    String? successMessage,
    String? errorMessage,
    bool clearSuccess = false,
    bool clearError = false,
  }) {
    return SubscriptionFormState(
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SubscriptionFormController extends StateNotifier<SubscriptionFormState> {
  SubscriptionFormController() : super(const SubscriptionFormState());

  static final _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  void updateEmail(String email) {
    state = state.copyWith(
      email: email.trim(),
      clearError: true,
      clearSuccess: true,
    );
  }

  String? validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) {
      return 'Ingresa tu correo electronico.';
    }
    if (!_emailRegex.hasMatch(email)) {
      return 'Ingresa un correo valido.';
    }
    return null;
  }

  Future<void> submit() async {
    final error = validateEmail(state.email);
    if (error != null) {
      state = state.copyWith(errorMessage: error, clearSuccess: true);
      return;
    }

    state = state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true);

    await Future<void>.delayed(const Duration(milliseconds: 850));

    state = state.copyWith(
      isSubmitting: false,
      successMessage: 'Gracias. Pronto te enviaremos los pasos para suscribirte.',
      clearError: true,
    );
  }
}
