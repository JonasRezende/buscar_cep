import 'package:buscar_cep/controllers/cep_controllers.dart';
import 'package:buscar_cep/views/search_cep_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => CepController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => SearchCepPage()),
      ];
}
