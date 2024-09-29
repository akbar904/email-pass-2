
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthError extends AuthState {
	final String message;
	AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
	AuthCubit() : super(AuthInitial());

	void login(String email, String password) async {
		emit(AuthLoading());

		// Simulating network request
		await Future.delayed(Duration(seconds: 1));

		if (email == 'test@example.com' && password == 'password') {
			emit(AuthAuthenticated());
		} else {
			emit(AuthError('Invalid credentials'));
		}
	}

	void logout() {
		emit(AuthInitial());
	}
}
