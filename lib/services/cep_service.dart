import 'dart:convert';

import 'package:buscar_cep/core/constants/constants.dart';
import 'package:buscar_cep/models/adress.dart';
import 'package:http/http.dart' as http;

class CepService {
  Future<Address?> fetchAddress(String cep) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null &&
          data is Map<String, dynamic> &&
          !data.containsKey('erro')) {
        return Address.fromJson(data);
      }
    }
    return null;
  }
}
