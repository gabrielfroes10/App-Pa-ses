import 'package:flutter/material.dart';
import '../models/country.dart';

void showCountryDetailsDialog(BuildContext context, Country country) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(country.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(country.flagUrl, width: 100)),
            SizedBox(height: 10),
            Text('Capital: ${country.capital}'),
            Text('Região: ${country.region}'),
            Text('Sub-região: ${country.subregion}'),
            Text('População: ${country.population}'),
            Text('Moeda: ${country.currency}'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Fechar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
