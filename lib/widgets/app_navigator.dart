import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safe_house/logic/cubit/auth_logic/auth_cubit.dart';
import 'package:safe_house/logic/cubit/session_logic/session_cubit.dart';
import 'package:safe_house/logic/cubit/session_logic/session_state.dart';
import 'package:safe_house/screens/home_screen.dart';
import 'package:safe_house/widgets/drawer_navbar.dart';

import 'auth_navigator.dart';
import 'loading_view.dart';

class AppNavigator extends StatefulWidget {
  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show loading screen
          if (state is UnknownSessionState)
            MaterialPage(child: Scaffold(body: CustomPageLoader())),

          // Show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: const AuthNavigator(),
              ),
            ),

          // Show session flow
          if (state is Authenticated)
            MaterialPage(child: const CustomDrawerNavigation()

                // ,
                // SessionView(
                //   userToken: state.userToken,
                // ),
                )
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
