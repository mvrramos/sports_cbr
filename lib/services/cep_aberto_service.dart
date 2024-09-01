import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sportscbr/models/cep_aberto_address.dart';

const token = "1d8011cca1633ee86c366e82f3c913e9";

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);
      if (response.data!.isEmpty) {
        return Future.error("CEP inválido");
      }
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data!);

      return address;
    } on DioException {
      return Future.error("Erro ao buscar CEP");
    }
  }
}
