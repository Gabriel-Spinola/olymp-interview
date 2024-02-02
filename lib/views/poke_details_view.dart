import 'package:flutter/material.dart';

import '../modules/poke_module.dart';

class PokeDetailsView extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String url;

  const PokeDetailsView({super.key, required this.url, required this.name, required this.imageUrl});

  @override
  State<PokeDetailsView> createState() => _PokeDetailsViewState();
}

class _PokeDetailsViewState extends State<PokeDetailsView> {
  late Future<PokemonModel> _pokemonData;

  @override
  void initState() {
    var apiService = PokemonAPI();
    _pokemonData = apiService.getPokemonData(widget.url);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          // COnsider remove
          child: Column(
            children: [
              // Title
              Builder(builder: (context) {
                  if (widget.imageUrl != null) {
                    return Image.network(widget.imageUrl!, width: 164,);
                  }

                  return FutureBuilder<PokemonModel>(
                      future: _pokemonData,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);

                          return const Text("Houve um erro ao carregar seu pokemon ):");
                        }

                        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                          return Image.network(snapshot.data!.image!, width: 124,);
                        }

                        return const CircularProgressIndicator();
                      }
                  );
              }),

              Builder(builder: (context) {
                if (widget.imageUrl != null) {
                  return Text(
                      widget.name!,
                      style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)
                  );
                }

                return FutureBuilder<PokemonModel>(
                    future: _pokemonData,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);

                        return const Text("Houve um erro ao carregar seu pokemon ):");
                      }

                      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                        return Text(
                            snapshot.data!.name,
                            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)
                        );
                      }

                      return const CircularProgressIndicator();
                    }
                );
              }),


              // API DATA
              FutureBuilder<PokemonModel>(
                  future: _pokemonData,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);

                      return const Text("Houve um erro ao carregar seu pokemon ):");
                    }

                    if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                      return _dataDisplay(snapshot.data!);
                    }

                    return const CircularProgressIndicator();
                  }
              ),

              Spacer(),
              // Go Back
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar!'),
              ),

              Spacer(),
            ],
          ),
      )
    );
  }

  Widget _dataDisplay(final PokemonModel data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Weight and Height
          Text("Altura: " + data.height.toString() + 'dm'),
          Text("Peso: " + data.weight.toString() + 'hg'),

          SizedBox(height: 32.0),

          // Habilities
          const Text("Habilidades", style: TextStyle(fontSize: 24.00)),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.habilities.length,
              itemBuilder: (context, index) {
                return Center(child: Text(data.habilities[index]));
              },
          ),

          SizedBox(height: 32.0),

          // Status
          const Text("Status", style: TextStyle(fontSize: 24.0)),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.stat.length,
            itemBuilder: (context, index) {
              return Center(child: Text(data.stat[index]));
            },
          ),

          SizedBox(height: 32.0),

          // Types
          const Text("Tipos", style: TextStyle(fontSize: 24.0)),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.type.length,
            itemBuilder: (context, index) {
              return Center(child: Text(data.type[index]));
            },
          ),
        ],
      ),
    );
  }
}
