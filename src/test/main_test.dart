
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:com.example.simple_app/main.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
	group('Main App Initialization', () {
		late AuthCubit authCubit;

		setUp(() {
			authCubit = MockAuthCubit();
		});

		testWidgets('App shows LoginScreen initially', (WidgetTester tester) async {
			await tester.pumpWidget(MyApp());

			expect(find.text('Login'), findsOneWidget);
			expect(find.byType(TextField), findsNWidgets(2)); // Email and Password fields
			expect(find.byType(ElevatedButton), findsOneWidget); // Login button
		});

		testWidgets('App navigates to HomeScreen on successful login', (WidgetTester tester) async {
			whenListen(authCubit, Stream<AuthState>.fromIterable([AuthState.authenticated('test@example.com')]));

			await tester.pumpWidget(BlocProvider.value(
				value: authCubit,
				child: MyApp(),
			));

			await tester.pumpAndSettle();

			expect(find.text('Home'), findsOneWidget);
			expect(find.byType(ElevatedButton), findsOneWidget); // Logout button
		});

		testWidgets('App shows LoginScreen on logout', (WidgetTester tester) async {
			whenListen(authCubit, Stream<AuthState>.fromIterable([
				AuthState.authenticated('test@example.com'),
				AuthState.unauthenticated(),
			]));

			await tester.pumpWidget(BlocProvider.value(
				value: authCubit,
				child: MyApp(),
			));

			await tester.pumpAndSettle();

			expect(find.text('Login'), findsOneWidget);
			expect(find.byType(TextField), findsNWidgets(2)); // Email and Password fields
			expect(find.byType(ElevatedButton), findsOneWidget); // Login button
		});
	});
}
