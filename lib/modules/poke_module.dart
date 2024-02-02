import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusModel {

}

class TypeModel {
  final String name;
  final String url;

  TypeModel({required this.name, required this.url});
}

class AbilityModel {
  final String name;
  final String url;

  AbilityModel({required this.name, required this.url});
}

class PokemonModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  //final TypeModel type;
  //final StatusModel stat;

  //final List<AbilityModel> abilities;

  PokemonModel({required this.id, required this.name, required this.height, required this.weight});

  factory PokemonModel.fromJson(Map<String, dynamic> jsonData) {
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
      ),
    _ => throw const FormatException("Failed to load avocado"),
    };
  }
}

class PokemonAPI {
  static const String _baseURL = 'https://pokeapi.co/api/v2/';

  Future<List<PokemonModel>> getPokemonList() async {
    final response = await http.get(Uri.parse(_baseURL + 'pokemon/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load avocado');
    }

    List<PokemonModel> pokemons = List.empty(growable: true);
    dynamic decoded = jsonDecode(response.body);

    print(decoded);

    for (Map<String, dynamic> data in decoded['data']) {
      //avocados.add(Po.fromJson(data));
    }

    return pokemons;
  }
}