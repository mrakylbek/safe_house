import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safe_house/api/api.dart';
import 'package:safe_house/constants/colors.dart';
import 'package:safe_house/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:safe_house/models/house.dart';
import 'package:safe_house/screens/add_house_screen.dart';
import 'package:safe_house/widgets/loading_view.dart';
import 'package:safe_house/widgets/page_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int currentPage = 0;
  late FirebaseMessaging messaging;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _firebaseListen();
  }

  void _firebaseListen() async {
    messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) async {
    //   print(value);
    //   try {
    //     await APIRepository().sendDeviceId(value!);

    //     print('AAAAA');
    //     final response = await APIRepository().sendDeviceId(value);
    //     print(response.data);
    //     if (response.data['data']['status'] == 'success') {
    //       setState(() {
    //         // status = SafetyStatus.safe;
    //         // bgColor = Colors.green;
    //         // statusText = 'Безопасно';
    //       });
    //     } else {
    //       setState(() {
    //         // status = SafetyStatus.unsafe;
    //         // bgColor = Colors.red;
    //         // statusText = 'Небезопасно';
    //       });
    //     }
    //   } on DioError catch (e) {
    //     if (e.response!.statusCode == 422) {
    //       print('BBBB');
    //       final response = await APIRepository().getStatus(value!);
    //       print(response.data);
    //       if (response.data['data']['status'] == 'success') {
    //         setState(() {
    //           // status = SafetyStatus.safe;
    //           // bgColor = Colors.green;
    //           // statusText = 'Безопасно';
    //         });
    //       } else {
    //         setState(() {
    //           // status = SafetyStatus.unsafe;
    //           // bgColor = Colors.red;
    //           // statusText = 'Небезопасно';
    //         });
    //       }
    //     }
    //   }
    // });
    // messaging.onTokenRefresh.listen((newToken) async {
    //   // Save newToken
    //   print('Token: $newToken');
    //   APIRepository().sendDeviceId(newToken);
    // });
    await messaging.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      BlocProvider.of<ProfileBloc>(context).add(ProfileFetchEvent());

      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('${event.notification!.title}'),
              content: Text(
                  '${event.notification!.body}\n\nНажмите на иконку под соответствующим домом, чтобы устранить опасность'),
              actions: [
                TextButton(
                  child: Text("Закрыть"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
      BlocProvider.of<ProfileBloc>(context).add(ProfileFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitialState || state is ProfileLoadingState) {
          return CustomPageLoader();
        } else if (state is ProfileSuccessState) {
          return Stack(
            children: [
              FlutterMap(
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
                                : 'assets/icons/home-green.png')),
                      );
                    },
                  ).toList()),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        offset: Offset(0, -4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          children: [
                            ...state.profile.houses.map((house) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                              'assets/images/house.png'),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: IconButton(
                                              onPressed: () async {
                                                await showCupertinoDialog(
                                                    context: context,
                                                    useRootNavigator: false,
                                                    builder: (_) {
                                                      bool _isLoading = false;
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return CupertinoAlertDialog(
                                                          title: const Text(
                                                              "Удалить"),
                                                          content: const Text(
                                                              "Вы точно хотите удалить объект?"),
                                                          actions: [
                                                            CupertinoDialogAction(
                                                                child: _isLoading
                                                                    ? CustomPageLoader()
                                                                    : Text(
                                                                        "Да"),
                                                                onPressed:
                                                                    () async {
                                                                  if (!_isLoading) {
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          true;
                                                                    });
                                                                    APIRepository()
                                                                        .deleteHouse(
                                                                            houseId: house
                                                                                .id!)
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                              .statusCode ==
                                                                          204) {
                                                                        BlocProvider.of<ProfileBloc>(context)
                                                                            .add(ProfileFetchEvent());
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Ошибка! Не удалось удалить объект')));
                                                                      }
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                    });
                                                                  }
                                                                }),
                                                            CupertinoDialogAction(
                                                                child:
                                                                    Text("Нет"),
                                                                onPressed: () {
                                                                  if (!_isLoading) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                })
                                                          ],
                                                        );
                                                      });
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.gas
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.gas!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.gas!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.gas?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/gas-red.png'
                                                  : 'assets/icons/gas-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.water
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.water!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.water!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.water?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/water-red.png'
                                                  : 'assets/icons/water-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.door
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.door!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.door!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.door?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/door-red.png'
                                                  : 'assets/icons/door-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.alarm
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.alarm!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.alarm!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.alarm?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/alarm-red.png'
                                                  : 'assets/icons/alarm-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.fire
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.fire!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.fire!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.fire?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/fire-red.png'
                                                  : 'assets/icons/fire-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.smoke
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.smoke!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.smoke!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.smoke?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/smoke-red.png'
                                                  : 'assets/icons/smoke-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              if (house.states.motion
                                                          ?.notification_id !=
                                                      null &&
                                                  house.states.motion!.slug ==
                                                      'warning') {
                                                await _resolveDangerDialog(
                                                    context,
                                                    house.states.motion!
                                                        .notification_id!);
                                              }
                                            },
                                            child: Image.asset(
                                              house.states.motion?.slug ==
                                                      'warning'
                                                  ? 'assets/icons/motion-red.png'
                                                  : 'assets/icons/motion-green.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${house.address}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (_) => AddHouseScreen()));
                              },
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  CircleBorder(),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        secondaryColor),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Добавить новый дом',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      state.profile.houses.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...state.profile.houses
                                    .asMap()
                                    .map((key, value) {
                                  return MapEntry(
                                    key,
                                    InkWell(
                                      onTap: () {
                                        _pageController.jumpToPage(key);
                                      },
                                      child: Container(
                                        height: 14,
                                        width: 14,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: currentPage == key
                                              ? Colors.white
                                              : Colors.white60,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  );
                                }).values,
                                InkWell(
                                  onTap: () {
                                    _pageController.jumpToPage(
                                        state.profile.houses.length);
                                  },
                                  child: Container(
                                    height: 14,
                                    width: 14,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: currentPage ==
                                              state.profile.houses.length
                                          ? Colors.white
                                          : Colors.white60,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 14,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
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

  _resolveDangerDialog(BuildContext context, int id) async {
    await showDialog(
        context: context,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text('Опасность устранена?'),
            actions: [
              TextButton(
                child: Text("Нет"),
                onPressed: () {
                  Navigator.of(context2).pop();
                },
              ),
              TextButton(
                child: Text("Да"),
                onPressed: () async {
                  await APIRepository().sendStatus(id).then((value) {
                    print(value.data);
                    BlocProvider.of<ProfileBloc>(context)
                        .add(ProfileFetchEvent());
                    Navigator.of(context2).pop();
                  });
                },
              )
            ],
          );
        });
  }
}
