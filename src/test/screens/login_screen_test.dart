
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:simple_app/screens/login_screen.dart';
import 'package:simple_app/cubits/auth_cubit.dart';
import 'package:bloc/bloc.dart';

// Mocking the AuthCubit
class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
	group('LoginScreen Widget Tests', () {
		late MockAuthCubit mockAuthCubit;

		setUp(() {
			mockAuthCubit = MockAuthCubit();
		});

		testWidgets('displays email and password fields and login button', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AuthCubit>.value(
						value: mockAuthCubit,
						child: LoginScreen(),
					),
				),
			);

			expect(find.byType(TextField), findsNWidgets(2)); // Email and Password fields
			expect(find.byType(ElevatedButton), findsOneWidget); // Login button
		});

		testWidgets('login button is disabled when email and password are empty', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AuthCubit>.value(
						value: mockAuthCubit,
						child: LoginScreen(),
					),
				),
			);

			final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
			expect(loginButton.onPressed, isNull);
		});

		testWidgets('shows error message when login fails', (WidgetTester tester) async {
			whenListen(
				mockAuthCubit,
				Stream<AuthState>.fromIterable([AuthState.loginFailure('Invalid credentials')]),
				initialState: AuthState.initial(),
			);

			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AuthCubit>.value(
						value: mockAuthCubit,
						child: LoginScreen(),
					),
				),
			);

			await tester.pump(); // Rebuild the widget with the new state

			expect(find.text('Invalid credentials'), findsOneWidget);
		});
	});

	group('AuthCubit Tests', () {
		late MockAuthCubit mockAuthCubit;

		setUp(() {
			mockAuthCubit = MockAuthCubit();
		});

		blocTest<MockAuthCubit, AuthState>(
			'emits [] when nothing is added',
			build: () => mockAuthCubit,
			expect: () => [],
		);

		blocTest<MockAuthCubit, AuthState>(
			'emits [AuthState.loginSuccess()] when login is successful',
			build: () => mockAuthCubit,
			act: (cubit) => cubit.login('test@example.com', 'password'),
			expect: () => [AuthState.loginSuccess()],
			verify: (_) {
				verify(() => mockAuthCubit.login('test@example.com', 'password')).called(1);
			},
		);

		blocTest<MockAuthCubit, AuthState>(
			'emits [AuthState.loginFailure()] when login fails',
			build: () => mockAuthCubit,
			act: (cubit) => cubit.login('test@example.com', 'wrong_password'),
			expect: () => [AuthState.loginFailure('Invalid credentials')],
			verify: (_) {
				verify(() => mockAuthCubit.login('test@example.com', 'wrong_password')).called(1);
			},
		);
	});
}
