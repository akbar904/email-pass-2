
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_app/cubits/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Login'),
			),
			body: BlocListener<AuthCubit, AuthState>(
				listener: (context, state) {
					if (state is AuthState.loginFailure) {
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text(state.errorMessage)),
						);
					}
				},
				child: Padding(
					padding: const EdgeInsets.all(16.0),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							TextField(
								controller: _emailController,
								decoration: InputDecoration(labelText: 'Email'),
							),
							TextField(
								controller: _passwordController,
								decoration: InputDecoration(labelText: 'Password'),
								obscureText: true,
							),
							SizedBox(height: 20),
							BlocBuilder<AuthCubit, AuthState>(
								builder: (context, state) {
									return ElevatedButton(
										onPressed: state is AuthState.loading
											? null
											: () {
												final email = _emailController.text;
												final password = _passwordController.text;
												if (email.isNotEmpty && password.isNotEmpty) {
													context.read<AuthCubit>().login(email, password);
												}
											},
										child: state is AuthState.loading
											? CircularProgressIndicator()
											: Text('Login'),
									);
								},
							),
						],
					),
				),
			),
		);
	}
}
