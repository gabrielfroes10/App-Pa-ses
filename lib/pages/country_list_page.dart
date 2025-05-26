import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../widgets/country_details_dialog.dart';

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<Country> allCountries = [];
  List<Country> displayedCountries = [];
  int currentIndex = 0;
  final int itemsPerPage = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      allCountries = data.map((item) => Country.fromJson(item)).toList();
      allCountries.sort((a, b) => a.name.compareTo(b.name));
      loadMoreCountries();
    } else {
      throw Exception('Erro ao carregar países');
    }
  }

  void loadMoreCountries() {
    final nextIndex = currentIndex + itemsPerPage;
    if (currentIndex < allCountries.length) {
      final newItems = allCountries.sublist(
        currentIndex,
        nextIndex > allCountries.length ? allCountries.length : nextIndex,
      );
      setState(() {
        displayedCountries.addAll(newItems);
        currentIndex = nextIndex;
        isLoading = false;
      });
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200 && !isLoading) {
      loadMoreCountries();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Lista de países',
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      automaticallyImplyLeading: false, // remove o botão de voltar ou menu
    ),
      body: isLoading && displayedCountries.isEmpty
          ? Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: ListView.builder(
                itemCount: displayedCountries.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= displayedCountries.length) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final country = displayedCountries[index];
                  return ListTile(
                    leading: Image.network(
                      country.flagUrl,
                      width: 50,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    title: Text(country.name),
                    onTap: () => showCountryDetailsDialog(context, country),
                  );
                },
              ),
            ),
    );
  }
}
