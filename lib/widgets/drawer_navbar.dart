// import 'package:eurasia_pass/presentation/screens/pass_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/api/api.dart';
import 'package:safe_house/constants/strings.dart';
import 'package:safe_house/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:safe_house/logic/cubit/session_logic/session_cubit.dart';
import 'package:safe_house/models/profile.dart';
import 'package:safe_house/repositories/profile_repository.dart';
import 'package:safe_house/screens/about_screen.dart';
import 'package:safe_house/screens/home_screen.dart';
import 'package:safe_house/screens/map_screen.dart';
import 'package:safe_house/screens/notifications_screen.dart';
import 'package:safe_house/screens/profile_screen.dart';
import 'package:safe_house/screens/settings_screen.dart';
import 'package:safe_house/widgets/loading_view.dart';
import 'package:safe_house/widgets/page_error.dart';

//bottom navbar with 4 tabs
class CustomDrawerNavigation extends StatefulWidget {
  const CustomDrawerNavigation({Key? key}) : super(key: key);

  @override
  _CustomDrawerNavigationState createState() => _CustomDrawerNavigationState();
}

class _CustomDrawerNavigationState extends State<CustomDrawerNavigation> {
  var _currentTab = Tabs.home;
  final _navigatorKeys = {
    Tabs.home: GlobalKey<NavigatorState>(),
    Tabs.profile: GlobalKey<NavigatorState>(),
    Tabs.history: GlobalKey<NavigatorState>(),
    Tabs.map: GlobalKey<NavigatorState>(),
    Tabs.settings: GlobalKey<NavigatorState>(),
    Tabs.about: GlobalKey<NavigatorState>(),
  };

  void _selectTab(Tabs tabItem) {
    keyDrawer.currentState!.openEndDrawer();

    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(repository: APIRepository())..add(ProfileFetchEvent()),
      child: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
          if (isFirstRouteInCurrentTab) {
            // if not on the 'main' tab
            if (_currentTab != Tabs.home) {
              // select 'main' tab
              _selectTab(Tabs.home);
              // back button handled by app
              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            leading: IconButton(
              onPressed: () {
                if (keyDrawer.currentState!.isDrawerOpen) {
                  keyDrawer.currentState!.openEndDrawer();
                } else {
                  keyDrawer.currentState!.openDrawer();
                }
              },
              icon: Icon(Icons.menu),
            ),
            title: Text('${menu[_currentTab.index]}'),
          ),
          body: Scaffold(
            key: keyDrawer,
            drawer: DrawerNavigation(
              currentTab: _currentTab,
              onSelectTab: _selectTab,
            ),
            body: Stack(fit: StackFit.expand, children: <Widget>[
              //tabs
              _buildOffstageNavigator(Tabs.home),
              _buildOffstageNavigator(Tabs.profile),
              _buildOffstageNavigator(Tabs.history),
              _buildOffstageNavigator(Tabs.map),
              _buildOffstageNavigator(Tabs.settings),
              _buildOffstageNavigator(Tabs.about),
            ]),
          ),
        ),
      ),
    );
  }

//tab
  Widget _buildOffstageNavigator(Tabs tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}

//bottom navbar
class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
  }) : super(key: key);
  final Tabs currentTab;
  final ValueChanged<Tabs> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              if (index == menu.length - 1) {
                BlocProvider.of<SessionCubit>(context).signOut();
              } else {
                onSelectTab(Tabs.values[index]);
              }
            },
            style: ButtonStyle(alignment: Alignment.centerLeft),
            child: Text(
              '${menu[index]}',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: menu.length,
      ),
    );
  }
}

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
  }) : super(key: key);
  final GlobalKey<NavigatorState>? navigatorKey;
  final Tabs tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, Tabs tab) {
    return {
      TabNavigatorRoutes.root: (context) {
        switch (tab) {
          case Tabs.home:
            return const HomeScreen();
          case Tabs.profile:
            return const ProfileScreen();
          case Tabs.history:
            return const NotificationsScreen();
          case Tabs.map:
            return const MapScreen();
          case Tabs.settings:
            return const SettingsScreen();
          case Tabs.about:
            return const AboutScreen();
          default:
            return const HomeScreen();
        }
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context, tabItem);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
