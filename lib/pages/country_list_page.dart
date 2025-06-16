import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../services/country_service.dart';
import '../widgets/country_details_dialog.dart';

class CountryListPage extends StatefulWidget {
  final CountryService countryService;

  CountryListPage({Key? key, CountryService? service})
      : countryService = service ?? CountryService(http.Client()),
        super(key: key);

  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<Country> allCountries = [];
  List<Country> displayedCountries = [];
  int currentIndex = 0;
  final int itemsPerPage = 10;
  bool isLoading = false;
  bool initialLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialCountries();
  }

  Future<void> _fetchInitialCountries() async {
    setState(() => initialLoading = true);
    try {
      allCountries = await widget.countryService.fetchCountries();
      loadMoreCountries();
    } catch (e) {
      print(e);
    } finally {
      if(mounted) {
        setState(() => initialLoading = false);
      }
    }
  }

  void loadMoreCountries() {
    if (isLoading) return;
    setState(() => isLoading = true);

    final nextIndex = currentIndex + itemsPerPage;
    if (currentIndex < allCountries.length) {
      final newItems = allCountries.sublist(
        currentIndex,
        nextIndex > allCountries.length ? allCountries.length : nextIndex,
      );
      setState(() {
        displayedCountries.addAll(newItems);
        currentIndex = nextIndex;
      });
    }
    setState(() => isLoading = false);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200 &&
        !isLoading) {
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
        automaticallyImplyLeading: false,
      ),
      body: initialLoading
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
                    key: Key('country_list_tile_${country.name}'),
                    leading: Image.network(
                      country.flagUrl,
                      width: 50,
                      height: 30,
                      fit: BoxFit.cover,
                      key: Key('flag_image_${country.name}'),
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