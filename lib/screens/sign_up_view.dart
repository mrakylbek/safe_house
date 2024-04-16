import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_house/constants/colors.dart';
import 'package:safe_house/logic/bloc/signup_logic/sign_up_bloc.dart';
import 'package:safe_house/logic/bloc/signup_logic/sign_up_event.dart';
import 'package:safe_house/logic/bloc/signup_logic/sign_up_state.dart';
import 'package:safe_house/logic/cubit/auth_logic/auth_cubit.dart';
import 'package:safe_house/repositories/auth_repository.dart';
import 'package:safe_house/widgets/form_submission_status.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        authRepo: context.read<AuthRepository>(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: primaryColor,
        body: Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Введите свои данные',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                _signUpForm(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.read<AuthCubit>().showLogin(),
                  style: const ButtonStyle(alignment: Alignment.center),
                  child: const Text(
                    'Авторизация',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _nameField(),
              const SizedBox(height: 10),
              _surnameField(),
              const SizedBox(height: 10),
              _emailField(),
              // _phoneField(),
              const SizedBox(height: 10),
              _passwordField(),
              const SizedBox(height: 10),
              _usernameField(),
              const SizedBox(height: 25),

              _signUpButton(),
            ],
          ),
        ));
  }

  Widget _nameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Name',
            border: InputBorder.none,
          ),
          // validator: (value) =>
          //     state.isValidUsername ? null : 'Username is too short',
          onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpNameChanged(name: value),
              ),
        ),
      );
    });
  }

  Widget _surnameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Surname',
            border: InputBorder.none,
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpSurnameChanged(surname: value),
              ),
        ),
      );
    });
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Username',
            border: InputBorder.none,
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpUsernameChanged(username: value),
              ),
        ),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Email',
            border: InputBorder.none,
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpEmailChanged(email: value),
              ),
        ),
      );
    });
  }

  Widget _phoneField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Phone',
            border: InputBorder.none,
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpPhoneChanged(phone: value),
              ),
        ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Password',
            border: InputBorder.none,
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(
                SignUpPasswordChanged(password: value),
              ),
        ),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<SignUpBloc>().add(SignUpSubmitted());
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text(
                'Зарегистрироваться',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            );
    });
  }

  Widget _showLoginButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Авторизация', style: TextStyle(color: Colors.black)),
        onPressed: () => context.read<AuthCubit>().showLogin(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
