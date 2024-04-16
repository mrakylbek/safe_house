import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safe_house/api/api.dart';
import 'package:safe_house/constants/colors.dart';
import 'package:safe_house/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:safe_house/widgets/loading_view.dart';

class AddHouseScreen extends StatefulWidget {
  const AddHouseScreen({Key? key}) : super(key: key);

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  TextEditingController controller = TextEditingController();
  LatLng? currentMarker;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Вернуться назад',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Введите адрес',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Address',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Укажите на карте',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              SizedBox(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(43.2338916 - 0.05, 76.9541347),
                    zoom: 11.0,
                    onTap: (position, latlng) {
                      setState(() {
                        currentMarker =
                            LatLng(latlng.latitude, latlng.longitude);
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: currentMarker != null
                          ? [
                              Marker(
                                width: 40.0,
                                height: 40.0,
                                point: currentMarker!,
                                child: Transform(
                                    transform:
                                        Matrix4.translationValues(0, -20, 0),
                                    child: Image.asset(
                                        'assets/icons/home-green.png')),
                              ),
                            ]
                          : [],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CustomPageLoader()
                  : OutlinedButton(
                      onPressed: () async {
                        if (!_isLoading) {
                          if (controller.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Укажите адрес'),
                            ));
                          } else if (currentMarker == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Укажите на карте'),
                            ));
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            APIRepository()
                                .addHouse(
                                    lat: '${currentMarker!.latitude}',
                                    let: '${currentMarker!.longitude}',
                                    address: controller.text)
                                .then((value) {
                              if (value.statusCode == 201) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Успешно добавлен'),
                                ));
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(ProfileFetchEvent());
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Ошибка! Повторитре еще раз'),
                                ));
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        'Добавить',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
