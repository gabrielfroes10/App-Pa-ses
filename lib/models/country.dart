class Country {
  final String name;
  final String flagUrl;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final String currency;

  Country({
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String currency = 'Desconhecida';
    if (json['currencies'] != null && json['currencies'] is Map) {
      final currencies = json['currencies'] as Map<String, dynamic>;
      if (currencies.isNotEmpty) {
        final firstKey = currencies.keys.first;
        currency = currencies[firstKey]['name'] ?? 'Desconhecida';
      }
    }
    return Country(
      name: json['name']['common'] ?? 'Sem nome',
      flagUrl: json['flags']['png'] ?? '',
      // CORREÇÃO: Adicionado "(as List)" para garantir que o tipo está correto
      capital: (json['capital'] != null && (json['capital'] as List).isNotEmpty)
          ? json['capital'][0]
          : 'Sem capital',
      region: json['region'] ?? 'Sem região',
      subregion: json['subregion'] ?? 'Sem sub-região',
      population: json['population'] ?? 0,
      currency: currency,
    );
  }
}