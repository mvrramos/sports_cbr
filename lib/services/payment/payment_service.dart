import 'package:sportscbr/models/data_user.dart';
import 'package:sportscbr/models/payment/credit_card.dart';

class PaymentService {
  void authorize({CreditCard? creditCard, num? price, String? orderId, DataUser? dataUser}) {
    final Map<String, dynamic> dataSale = {
      'orderId': orderId,
      'price': price?.toInt(),
      'descriptor': "Sports CBR",
      'installments': 1,
      'creditCard': creditCard!.toMap(),
      'cpf': dataUser!.cpf,
      'paymentType': 'CreditCard'
    };
  }
}
