
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:simple_app/screens/home_screen.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
	group('HomeScreen Widget Tests', () {
		testWidgets('displays logout button', (WidgetTester tester) async {
			await tester.pumpWidget(
				BlocProvider<AuthCubit>(
					create: (_) => MockAuthCubit(),
					child: HomeScreen(),
				),
			);

			expect(find.text('Logout'), findsOneWidget);
		});

		testWidgets('calls logout on button press', (WidgetTester tester) async {
			final mockAuthCubit = MockAuthCubit();

			await tester.pumpWidget(
				BlocProvider<AuthCubit>(
					create: (_) => mockAuthCubit,
					child: HomeScreen(),
				),
			);

			await tester.tap(find.text('Logout'));
			await tester.pump();

			verify(() => mockAuthCubit.logout()).called(1);
		});
	});
}
