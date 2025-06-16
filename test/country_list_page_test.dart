import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:network_image_mock/network_image_mock.dart';

import 'package:app_paises/models/country.dart';
import 'package:app_paises/pages/country_list_page.dart';
import 'package:app_paises/services/country_service.dart';


@GenerateMocks([http.Client])
import 'country_list_page_test.mocks.dart';

void main() {
  final mockApiResponse = jsonEncode([
    {
      "name": {"common": "Brazil"}, "capital": ["Brasília"], "region": "Americas", "subregion": "South America", "population": 212559409, "flags": {"png": "https://flagcdn.com/w320/br.png"}, "currencies": { "BRL": {"name": "Brazilian real"} }
    },
    {
      "name": {"common": "Argentina"}, "capital": ["Buenos Aires"], "region": "Americas", "subregion": "South America", "population": 45376763, "flags": {"png": "https://flagcdn.com/w320/ar.png"}, "currencies": { "ARS": {"name": "Argentine peso"} }
    }
  ]);

  late MockClient mockClient;
  late CountryService countryService;

  setUp(() {
    mockClient = MockClient();
    countryService = CountryService(mockClient);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: CountryListPage(service: countryService),
    );
  }
  
  // Função para definir o tamanho da tela do teste
  void setScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
  }

  mockNetworkImagesFor(() {
    group('CountryListPage Tests', () {
      testWidgets('Cenário 01: Verificar se o nome do país é carregado', (tester) async {
        setScreenSize(tester); // Define o tamanho da tela
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response(mockApiResponse, 200));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Brazil'), findsOneWidget);
        expect(find.text('Argentina'), findsOneWidget);
        
        addTearDown(tester.view.reset); // Limpa o tamanho da tela
      });

      testWidgets('Cenário 03: Verificar se a bandeira é carregada', (tester) async {
        setScreenSize(tester); // Define o tamanho da tela
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response(mockApiResponse, 200));
            
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('flag_image_Brazil')), findsOneWidget);

        addTearDown(tester.view.reset); // Limpa o tamanho da tela
      });

      testWidgets('Cenário 02: Verificar se ao clicar os dados são abertos', (tester) async {
        setScreenSize(tester); // Define o tamanho da tela
        when(mockClient.get(any))
            .thenAnswer((_) async => http.Response(mockApiResponse, 200));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final tile = find.byKey(const Key('country_list_tile_Argentina'));
        expect(tile, findsOneWidget);
        await tester.tap(tile);
        await tester.pumpAndSettle();

        expect(find.text('Argentina'), findsWidgets);
        expect(find.text('Capital: Buenos Aires'), findsOneWidget);

        addTearDown(tester.view.reset); // Limpa o tamanho da tela
      });
    });
  });
}