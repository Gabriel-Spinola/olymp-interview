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
  static const String _baseURL = 'https://pokeapi.co/api/v2/';

  Future<List<PokemonListModel>> getPokemonList() async {
    final response = await http.get(Uri.parse(_baseURL + 'pokemon/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load avocado');
    }

    List<PokemonListModel> pokemons = List.empty(growable: true);
    dynamic decoded = jsonDecode(response.body);

    print(decoded);

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
      throw Exception('Failed to load avocado');
    }

    dynamic decoded = jsonDecode(response.body);

    print(decoded);

    return decoded['sprites']['front_default'];
  }

  /*Future<PokemonModel> getPokemonData() async {

  }*/
}