import 'dart:async';

import 'package:desktop/views/home_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    _startTime();
  }

  Future<Timer> _startTime() async {
    var duration = const Duration(seconds: 0);
    
    return Timer(
        duration,
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => const  HomeView())
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),

          SizedBox(height: 124.0,),
          Image.asset("lib/assets/logo.png", width: 124.0 * 4, height: 124.0 * 4, scale: .6,),
          Spacer(),

          CircularProgressIndicator(),
          Spacer(),
        ],
      ),
    );
  }
}
