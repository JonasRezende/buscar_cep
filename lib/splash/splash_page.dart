import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Modular.to.navigate('/cep'); // Certifique-se de que a rota está correta
    });

    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Pode ser sua logo ou indicador de carregamento
      ),
    );
  }
}
