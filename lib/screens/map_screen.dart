import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safe_house/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:safe_house/widgets/loading_view.dart';
import 'package:safe_house/widgets/page_error.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitialState || state is ProfileLoadingState) {
          return CustomPageLoader();
        } else if (state is ProfileSuccessState) {
          return FlutterMap(
            options: MapOptions(
              center: LatLng(43.2338916 - 0.05, 76.9541347),
              zoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                  markers: state.profile.houses.map(
                (house) {
                  bool _isWarningState = false;
                  if (house.states.water?.slug == 'warning' ||
                      house.states.door?.slug == 'warning' ||
                      house.states.gas?.slug == 'warning') {
                    _isWarningState = true;
                  }
                  return Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(
                        double.parse(house.lat!), double.parse(house.let!)),
                    child: Transform(
                      transform: Matrix4.translationValues(0, -20, 0),
                      child: Image.asset(_isWarningState
                          ? 'assets/icons/home-red.png'
                          : 'assets/icons/home-green.png'),
                    ),
                  );
                },
              ).toList()),
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
