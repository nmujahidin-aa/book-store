class AuthState {
  final bool isAuthenticated;
  final bool justRegistered;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.justRegistered = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? justRegistered,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      justRegistered: justRegistered ?? this.justRegistered,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
