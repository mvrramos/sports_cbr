class CepAbertoAddress {
  final double altitude;
  final double latitude;
  final double longitude;
  final String cep;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoAddress.fromMap(Map<String, dynamic> map)
      : altitude = double.tryParse(map['altitude'].toString()) ?? 0.0,
        latitude = double.tryParse(map['latitude'].toString()) ?? 0.0,
        longitude = double.tryParse(map['longitude'].toString()) ?? 0.0,
        cep = map['cep'] as String? ?? '',
        logradouro = map['logradouro'] as String? ?? '',
        bairro = map['bairro'] as String? ?? '',
        cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
        estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoAddress(altitude: $altitude, latitude: $latitude, longitude: $longitude, cep: $cep, logradouro: $logradouro, bairro: $bairro, cidade: ${cidade.nome}, estado: ${estado.sigla})';
  }
}

class Cidade {
  final String nome;
  final String ibge;

  Cidade.fromMap(Map<String, dynamic> map)
      : nome = map['nome'] as String? ?? '',
        ibge = map['ibge'] as String? ?? '';

  @override
  String toString() => 'Cidade(nome: $nome, ibge: $ibge)';
}

class Estado {
  final String sigla;

  Estado.fromMap(Map<String, dynamic> map) : sigla = map['sigla'] as String? ?? '';

  @override
  String toString() => 'Estado(sigla: $sigla)';
}
