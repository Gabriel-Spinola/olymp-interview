import 'package:flutter/material.dart';

class PokeDetailsView extends StatefulWidget {
  final String url;

  const PokeDetailsView({super.key, required this.url});

  @override
  State<PokeDetailsView> createState() => _PokeDetailsViewState();
}

class _PokeDetailsViewState extends State<PokeDetailsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello, World"),
    );
  }
}
