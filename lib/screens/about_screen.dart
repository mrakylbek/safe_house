import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text =
        "Датчики для охранных систем – современные устройства на базе GSM модуля, контролирующие движение, задымленность, влажность, открывание дверей и другие параметры. Если на объекте случается происшествие, на которое может среагировать датчик, например, несанкционированное проникновение или возгорание, устройство срабатывает, подавая сигнал через GSM модуль на центральную панель сигнализации:\n\n\t\t\t- Датчик движения\n\t\t\t- Датчик протечки воды\n\t\t\t- Датчик дыма\n\t\t\t- Датчик открытия двери\n\t\t\t- Датчик утечки газа\n\t\t\t- Датчик температуры\n\t\t\t- Внутренная сирена";
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
