import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:safe_house/models/profile.dart';
import 'package:safe_house/repositories/profile_repository.dart';
import 'package:safe_house/widgets/loading_view.dart';
import 'package:safe_house/widgets/page_error.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitialState || state is ProfileLoadingState) {
          return CustomPageLoader();
        } else if (state is ProfileSuccessState) {
          return ListView(
            padding: EdgeInsets.all(30),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '${state.profile.surname} ${state.profile.name} ${state.profile.patronymic}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '${state.profile.email}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.edit_notifications,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      state.profile.notification == '2'
                          ? 'Уведомления включены'
                          : 'Уведомления выключены',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (state is ProfileErrorState) {
          return CustomPageError();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
