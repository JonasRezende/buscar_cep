import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Redireciona para a tela de busca de CEP após um atraso de 2 segundos
    Future.delayed(Duration(seconds: 2), () {
      Modular.to.navigate('/cep'); // Navegação para a página de busca de CEP
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Caminho da imagem logo
          width: 200, // Largura da imagem
          height: 200, // Altura da imagem
          fit: BoxFit.contain, // Ajusta a imagem para caber na tela
        ),
      ),
    );
  }
}
