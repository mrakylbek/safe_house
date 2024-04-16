import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_house/constants/colors.dart';
import 'package:safe_house/logic/bloc/login_logic/login_bloc.dart';
import 'package:safe_house/logic/bloc/login_logic/login_event.dart';
import 'package:safe_house/logic/bloc/login_logic/login_state.dart';
import 'package:safe_house/logic/cubit/auth_logic/auth_cubit.dart';
import 'package:safe_house/repositories/auth_repository.dart';
import 'package:safe_house/widgets/form_submission_status.dart';

class AuthorizationScreen extends StatelessWidget {
  static const routeName = '/authorization';

  final _formKey = GlobalKey<FormState>();

  AuthorizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LocalizationBloc localizationBlocProvider =
    //     BlocProvider.of<LocalizationBloc>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            authRepo: context.read<AuthRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
        )
      ],
      child: Scaffold(
        extendBody: true,
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.topCenter,
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      _loginForm(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TextButton(
                          //   onPressed: () {},
                          //   child: Text(
                          //     'Забыли пароль?',
                          //     // style: const TextStyle(
                          //     //   // color: LIGHT_BLUE_COLOR,
                          //     //   fontSize: 16,
                          //     //   fontWeight: FontWeight.w500,
                          //     // ).merge(CustomTextStyle.allFontStyle),
                          //   ),
                          // ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () =>
                                context.read<AuthCubit>().showSignUp(),
                            child: Text(
                              'Регистрация',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Flexible(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ваш username',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _usernameField(),
                const SizedBox(height: 20),
                Text(
                  'Пароль',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _passwordField(),
            const SizedBox(height: 25),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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
          decoration: InputDecoration(
            icon: SvgPicture.asset(
              'assets/icons/at-sign.svg',
              color: Colors.black,
            ),
            hintText: 'Username',
            border: InputBorder.none,
          ),
          // validator: (value) =>
          //     state.isValidUsername ? null : 'Username is too short',
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginUsernameChanged(username: value),
              ),
        ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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

          decoration: InputDecoration(
            icon: SvgPicture.asset(
              'assets/icons/lock.svg',
              color: Colors.black,
            ),
            hintText: 'Пароль',
            border: InputBorder.none,
          ),
          // validator: (value) =>
          //     state.isValidPassword ? null : 'Password is too short',
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginPasswordChanged(password: value),
              ),
        ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text(
                'Войти',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
