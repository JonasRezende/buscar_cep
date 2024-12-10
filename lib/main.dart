import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/app_module.dart'; // Importa o módulo que contém a configuração

void main() {
  runApp(
    ModularApp(
      module: AppModule(), // Inicializa o módulo principal
      child: MyApp(), // Adiciona o widget MyApp como a raiz
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buscar CEP',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFFFBBA2B)),
      ),
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}

// Função para criar um MaterialColor a partir de uma cor base
MaterialColor createMaterialColor(Color color) {
  Map<int, Color> colorSwatch = {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color,
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1.0),
  };
  return MaterialColor(color.value, colorSwatch);
}
