import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/api/api.dart';
import 'package:safe_house/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:safe_house/widgets/loading_view.dart';
import 'package:safe_house/widgets/page_error.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool _isTurnOn = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Уведомления',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 20),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileInitialState ||
                      state is ProfileLoadingState) {
                    return CustomPageLoader();
                  } else if (state is ProfileSuccessState) {
                    bool _isTurnOn =
                        state.profile.notification == '2' ? true : false;
                    return Switch(
                      value: _isTurnOn,
                      onChanged: (value) async {
                        try {
                          await APIRepository().updateUser(
                            userId: state.profile.id!,
                            status: !_isTurnOn ? 2 : 1,
                          );
                          BlocProvider.of<ProfileBloc>(context)
                              .add(ProfileFetchEvent());
                        } on DioError catch (e) {
                          throw Exception(e);
                        }

                        // setState(() {
                        //   _isTurnOn = !_isTurnOn;
                        // });
                      },
                      activeColor: Colors.white,
                    );
                  } else if (state is ProfileErrorState) {
                    return CustomPageError();
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitialState || state is ProfileLoadingState) {
          return CustomPageLoader();
        } else if (state is ProfileSuccessState) {
        } else if (state is ProfileErrorState) {
          return CustomPageError();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
