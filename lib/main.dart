import 'package:flutter/material.dart';
import 'pages/country_list_page.dart';

void main() {
  runApp(CountryApp());
}

class CountryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Países do Mundo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CountryListPage(),
    );
  }
}
