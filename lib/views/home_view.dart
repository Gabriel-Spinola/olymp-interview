import 'package:desktop/modules/poke_module.dart';
import 'package:desktop/views/poke_details_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<PokemonListModel>> _pokemonData;

  @override
  void initState() {
    var apiService = PokemonAPI();
    _pokemonData = apiService.getPokemonList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(72.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<List<PokemonListModel>>(
                  future: _pokemonData,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);

                      return const Text("Houve um erro ao carregar seu pokemon ):");
                    }

                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Text("Nenhum pokemon encontrado");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return _dataColumn(snapshot.data!);
                    }

                    return const CircularProgressIndicator();
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataColumn(final List<PokemonListModel> data) {
    // TODO - Hover + Border
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      data[index].name,
                      style: TextStyle(fontSize: 32.0)
                    ),
                    Spacer(),
                    // 112
                    Image.network(data[index].imageUrl, width: 122,),
                  ],
                ),
              ),
              onTap: () => Navigator.push(
                context, MaterialPageRoute(
                  builder: (ctx) => PokeDetailsView(
                    url: data[index].url,
                    name: data[index].name,
                    imageUrl: data[index].imageUrl,
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
