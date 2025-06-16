import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  final http.Client client;

  CountryService(this.client);

  Future<List<Country>> fetchCountries() async {
    final response =
        await client.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final countries = data.map((item) => Country.fromJson(item)).toList();
      countries.sort((a, b) => a.name.compareTo(b.name));
      return countries;
    } else {
      throw Exception('Erro ao carregar países');
    }
  }
}