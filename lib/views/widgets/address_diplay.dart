import 'package:buscar_cep/models/adress.dart';
import 'package:flutter/material.dart';

class AddressDisplay extends StatelessWidget {
  final Address address;

  const AddressDisplay({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
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
}
