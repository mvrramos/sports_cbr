import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';

class CreditCard {
  String? number;
  String? holder;
  String? expirationDate;
  String? securityCode;
  String? brand;

  void setHolder(String name) => holder = name;

  void setExpirationDate(String date) => expirationDate = date;

  void setCvv(String cvv) => securityCode = cvv;

  void setNumber(String number) {
    this.number = number;

    String cleanNumber = number.replaceAll(' ', '');
    final detectedTypes = detectCCType(cleanNumber);

    if (detectedTypes.isNotEmpty) {
      brand = getBrandName(detectedTypes as CreditCardType);
    } else {
      brand = 'Unknown';
    }
  }

  String getBrandName(CreditCardType type) {
    switch (type) {
      case CreditCardType.visa:
        return 'Visa';
      case CreditCardType.mastercard:
        return 'Mastercard';
      case CreditCardType.americanExpress:
        return 'American Express';
      case CreditCardType.discover:
        return 'Discover';
      case CreditCardType.jcb:
        return 'JCB';
      case CreditCardType.dinersClub:
        return 'Diners Club';
      case CreditCardType.unionPay:
        return 'UnionPay';
      default:
        return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'CreditCard{number: $number, holder: $holder, expirationDate: $expirationDate, securityCode: $securityCode, brand: $brand}';
  }
}
