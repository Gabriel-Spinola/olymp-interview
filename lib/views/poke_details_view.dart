import 'package:flutter/material.dart';

import '../modules/poke_module.dart';

class PokeDetailsView extends StatefulWidget {
  final String name;
  final String imageUrl;
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Image.network(widget.imageUrl, width: 124,),
                  Text(widget.name),
            
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
            ),
          )
    );
  }

  Widget _dataDisplay(final PokemonModel data) {
    return Column(
      children: [
        // Weight and Height
        Text(data.height.toString()),
        Text(data.weight.toString()),

        // Habilities
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.habilities.length,
            itemBuilder: (context, index) {
              return Text(data.habilities[index]);
            },
        ),

        // Status
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.stat.length,
          itemBuilder: (context, index) {
            return Text(data.stat[index]);
          },
        ),

        // Types
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.type.length,
          itemBuilder: (context, index) {
            return Text(data.type[index]);
          },
        ),
      ],
    );
  }
}
