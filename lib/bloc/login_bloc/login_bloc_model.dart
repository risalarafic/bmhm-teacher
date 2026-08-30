class LoginBlocModel {
  LoginBlocModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.obscurePassword = true,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool obscurePassword;

  LoginBlocModel copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? obscurePassword,
  }) {
    return LoginBlocModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
