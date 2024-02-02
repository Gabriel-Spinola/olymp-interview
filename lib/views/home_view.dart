import 'package:desktop/modules/poke_module.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<PokemonModel>> _pokemonData;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<List<PokemonModel>>(
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
                    //return _dataColumn(snapshot.data!);
                  }
        
                  return const CircularProgressIndicator();
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataColumn(final List<PokemonModel> data) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Text("");
        }
    );
  }
}
