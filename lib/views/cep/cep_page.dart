import 'package:buscar_cep/controllers/cep_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchCepPage extends StatelessWidget {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<CepController>();

    return Scaffold(
      appBar: AppBar(title: Text('Buscar CEP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: cepController,
              decoration: InputDecoration(labelText: 'Digite o CEP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await controller.searchCep(cepController.text);
              },
              child: Text('Buscar'),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<CepState>(
              valueListenable: controller.stateNotifier,
              builder: (context, state, _) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Text(
                    state.error!,
                    style: TextStyle(color: Colors.red),
                  );
                }
                if (state.address != null) {
                  final address = state.address!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rua: ${address.logradouro}'),
                      Text('Bairro: ${address.bairro}'),
                      Text('Cidade: ${address.localidade}'),
                      Text('UF: ${address.uf}'),
                    ],
                  );
                }
                return Text('Nenhum dado disponível.');
              },
            ),
          ],
        ),
      ),
    );
  }
}
