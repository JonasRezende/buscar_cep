import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/app_module.dart'; // Certifique-se de que este é o caminho correto

void main() {
  runApp(
    ModularApp(
      module: AppModule(), // Inicializa o AppModule
      child: const MyApp(), // Widget principal do aplicativo
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buscar CEP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate:
          Modular.routerDelegate, // Configuração de rotas do Modular
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}
