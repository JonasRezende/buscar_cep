import 'package:buscar_cep/controllers/cep_controllers.dart';
import 'package:buscar_cep/views/cep/cep_page.dart'; // Import correto da página
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => CepController()), // Vincula o controlador
      ];

  @override
  List<ModularRoute> get routes => [
        // Define a rota inicial
        ChildRoute('/',
            child: (context, args) => CepPage()), // Página inicial é a CepPage
      ];
}
