import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> keyDrawer = GlobalKey();
enum Tabs { home, profile, history, map, settings, about }
List<String> menu = [
  'Главная страница',
  'Личный кабинет',
  'История событий',
  'Карта',
  'Настройки',
  'О приложении',
  'Выйти'
];
