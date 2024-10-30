import 'package:cloud_firestore/cloud_firestore.dart';
import '../address.dart';
import '../cart/cart_manager.dart';
import '../cart/cart_product.dart';

enum Status {
  canceled,
  preparing,
  transporting,
  delivered,
}

class Orders {
  String? orderId;
  String? userId;
  List<CartProduct>? items;
  num? price;

  Status? status;
  Address? address;
  Timestamp? date;

  String get formattedId => '#${orderId!.padLeft(5, '0')}';
  String get statusText => getStatusText(status!);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.collection('orders').doc(orderId);

  Orders.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.dataUser!.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Orders.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;
    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'] as num;
    userId = doc['user'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);
    date = doc['date'] as Timestamp;
    status = Status.values[doc['status'] as int];
  }

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items!.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address!.toMap(),
      'date': Timestamp.now(),
      'status': status?.index,
    });
  }

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return "Cancelado";
      case Status.preparing:
        return "Em preparo";
      case Status.transporting:
        return "Em transporte";
      case Status.delivered:
        return "Entregue";
      default:
        return '';
    }
  }

  Function()? get back {
    return status!.index >= Status.transporting.index
        ? () {
            status = Status.values[status!.index - 1];
            firestoreRef.update({
              'status': status!.index
            });
          }
        : null;
  }

  Function()? get advance {
    return status!.index <= Status.transporting.index
        ? () {
            status = Status.values[status!.index + 1];
            firestoreRef.update({
              'status': status!.index
            });
          }
        : null;
  }

  void cancel() {
    status = Status.canceled;
    firestoreRef.update({
      'status': status!.index
    });
  }

  @override
  String toString() {
    return "Orders{orderId: $orderId, items, $items, price: $price, userId: $userId, address: $address, status: $status, date: $date}";
  }
}
