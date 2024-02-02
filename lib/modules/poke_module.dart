import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> habilities;
  final List<String> stat;
  final List<String> type;

  String? image;

  //final List<AbilityModel> abilities;

  PokemonModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.habilities,
    required this.stat,
    required this.type,
  });

  /*factory PokemonModel.fromJson(Map<String, dynamic> jsonData) {
    return switch (jsonData) {
      {
        'id': int id,
        'name': String name,
        'height': int height,
        'weight': int weight,
      } => PokemonModel(
        id: id,
        name: name,
        height: height,
        weight: weight,
        hability: '',
      ),
    _ => throw const FormatException("Failed to load avocado"),
    };
  }*/

  factory PokemonModel.fromJson(Map<String, dynamic> jsonData) {
    return PokemonModel(
      id: jsonData['id'],
      name: jsonData['name'],
      height: jsonData['height'],
      weight: jsonData['weight'],
      habilities: jsonData['habilities'],
      stat: jsonData['stat'],
      type: jsonData['type'],
    );
  }
}

class PokemonListModel {
  final String name;
  final String url;
  final String imageUrl;

  PokemonListModel({required this.imageUrl, required this.name, required this.url});

  factory PokemonListModel.fromJson(Map<String, dynamic> jsonData) {
    return PokemonListModel(
      name: jsonData['name'].toString(),
      url: jsonData['url'].toString(),
      imageUrl: jsonData['imageUrl'],
    );
  }
}

class PokemonAPI {
  static const String baseURL = 'https://pokeapi.co/api/v2/';

  Future<List<PokemonListModel>> getPokemonList() async {
    final response = await http.get(Uri.parse(baseURL + 'pokemon/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load avocado');
    }

    List<PokemonListModel> pokemons = List.empty(growable: true);
    dynamic decoded = jsonDecode(response.body);

    for (Map<String, dynamic> data in decoded['results']) {
      var imageURL = await getImageFromNamedResource(data['url'].toString());
      data.putIfAbsent('imageUrl', () => imageURL);

      pokemons.add(PokemonListModel.fromJson(data));
    }

    return pokemons;
  }

  Future<String> getImageFromNamedResource(String targetUrl) async {
    final response = await http.get(Uri.parse(targetUrl));

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to load avocado');
    }

    dynamic decoded = jsonDecode(response.body);

    return decoded['sprites']['front_default'];
  }

  Future<PokemonModel> getPokemonData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load pokemon data');
    }

    dynamic decoded = jsonDecode(response.body);
    List<String> types = List.empty(growable: true);
    List<String> habilities = List.empty(growable: true);
    List<String> stats = List.empty(growable: true);

    for (Map<String, dynamic> data in decoded['types']) {
      types.add(data['type']['name']);
    }

    for (Map<String, dynamic> data in decoded['stats']) {
      habilities.add(data['stat']['name']);
    }

    for (Map<String, dynamic> data in decoded['abilities']) {
      stats.add(data['ability']['name']);
    }

    var poke = PokemonModel(
        id: decoded['id'],
        name: decoded['name'],
        height: decoded['height'],
        weight: decoded['weight'],
        habilities: habilities,
        stat: stats,
        type: types
    );

    poke.image = decoded['sprites']['front_default'];

    return poke;
  }
}