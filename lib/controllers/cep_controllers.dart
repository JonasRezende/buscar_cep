import 'dart:convert';

import 'package:buscar_cep/models/adress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CepState {
  final bool isLoading;
  final String? error;
  final Address? address;

  CepState({
    required this.isLoading,
    this.error,
    this.address,
  });

  CepState copyWith({
    bool? isLoading,
    String? error,
    Address? address,
  }) {
    return CepState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      address: address,
    );
  }
}

class CepController {
  final ValueNotifier<CepState> stateNotifier =
      ValueNotifier(CepState(isLoading: false));

  CepState get state => stateNotifier.value;

  Future<void> searchCep(String cep) async {
    if (!_validateCep(cep)) {
      stateNotifier.value = state.copyWith(
        isLoading: false,
        error: 'CEP inválido. Por favor, insira um CEP com 8 dígitos.',
        address: null,
      );
      return;
    }

    stateNotifier.value = state.copyWith(isLoading: true, error: null);

    try {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data is Map<String, dynamic> &&
            !data.containsKey('erro')) {
          final address = Address.fromJson(data);
          stateNotifier.value = state.copyWith(
            isLoading: false,
            address: address,
            error: null,
          );
        } else {
          stateNotifier.value = state.copyWith(
            isLoading: false,
            error: 'CEP não encontrado.',
            address: null,
          );
        }
      } else {
        stateNotifier.value = state.copyWith(
          isLoading: false,
          error: 'Erro ao buscar o CEP.',
        );
      }
    } catch (e) {
      stateNotifier.value = state.copyWith(
        isLoading: false,
        error: 'Erro ao buscar o CEP. Tente novamente.',
      );
    }
  }

  bool _validateCep(String cep) {
    final regex = RegExp(r'^\d{8}$');
    return regex.hasMatch(cep);
  }
}
