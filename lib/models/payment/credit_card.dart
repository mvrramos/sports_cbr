import 'package:credit_card_type_detector/credit_card_type_detector.dart';

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
    var detectedTypes = detectCCType(number.replaceAll(' ', ''));

    if (detectedTypes.isNotEmpty) {
      brand = detectedTypes.first.type;
    } else {
      brand = "Unknown";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': number!.replaceAll(' ', ''),
      'holder': holder,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': brand,
    };
  }

  @override
  String toString() {
    return 'CreditCard(number: $number, holder: $holder, expirationDate: $expirationDate, securityCode: $securityCode, brand: $brand)';
  }
}
