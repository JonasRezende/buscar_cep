import 'package:buscar_cep/core/utils/helpers.dart';
import 'package:buscar_cep/models/adress.dart';
import 'package:buscar_cep/services/cep_service.dart';
import 'package:flutter/material.dart';

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
  final CepService service = CepService();
  final ValueNotifier<CepState> stateNotifier =
      ValueNotifier(CepState(isLoading: false));

  CepState get state => stateNotifier.value;

  Future<void> searchCep(String cep) async {
    // Verifica se o CEP é válido usando o método estático Helpers.isValidCep
    if (!Helpers.isValidCep(cep)) {
      stateNotifier.value = state.copyWith(
        isLoading: false,
        error: 'CEP inválido. Deve conter 8 dígitos.',
      );
      return;
    }

    stateNotifier.value = state.copyWith(isLoading: true, error: null);

    try {
      final address = await service.fetchAddress(cep);
      if (address != null) {
        stateNotifier.value = state.copyWith(
          isLoading: false,
          address: address,
          error: null,
        );
      } else {
        stateNotifier.value = state.copyWith(
          isLoading: false,
          error: 'CEP não encontrado.',
        );
      }
    } catch (e) {
      stateNotifier.value = state.copyWith(
        isLoading: false,
        error: 'Erro ao buscar o CEP.',
      );
    }
  }
}
