import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/cep/cep_aberto_service.dart';
import '../address.dart';
import '../data_user.dart';
import '../product/product.dart';
import '../user/user_manager.dart';
import 'cart_product.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];
  DataUser? dataUser;
  Address? address;

  num productsPrice = 200;
  num deliveryPrice = 0;
  num get totalPrice => productsPrice + deliveryPrice;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateUser(UserManager userManager) {
    dataUser = userManager.dataUser;
    productsPrice = 0;
    items.clear();
    removeAddress();

    if (dataUser != null) {
      _loadCartItems();
      _loadUserAddress();
    } else {}
  }

  Future<void> _loadCartItems() async {
    if (dataUser?.cartReference != null) {
      final QuerySnapshot cartSnap = await dataUser!.cartReference.get();

      items = cartSnap.docs.map((doc) => CartProduct.fromDocument(doc)..addListener(_onItemUpdated)).toList();
      notifyListeners();
    }
  }

  Future<void> _loadUserAddress() async {
    if (dataUser?.address != null) {
      final Address userAddress = dataUser!.address!;
      if (userAddress.lat != null && userAddress.long != null) {
        if (await calculateDelivery(userAddress.lat!, userAddress.long!)) {
          address = userAddress;
          notifyListeners();
        }
      }
    }
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
      _onItemUpdated();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      dataUser!.cartReference.add(cartProduct.toCartItemMap()).then((doc) {
        cartProduct.id = doc.id;
        _onItemUpdated();
      });
      notifyListeners();
    }
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    dataUser!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0;

    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    dataUser!.cartReference.doc(cartProduct.id).update(cartProduct.toCartItemMap());
    notifyListeners();
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  void clear() {
    for (final cartProduct in items) {
      dataUser!.cartReference.doc(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }

  // Address
  bool get isAddressValid => address != null && deliveryPrice != 0;

  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      address = Address(
        street: cepAbertoAddress.logradouro,
        district: cepAbertoAddress.bairro,
        zipCode: cepAbertoAddress.cep,
        city: cepAbertoAddress.cidade.nome,
        state: cepAbertoAddress.estado.sigla,
        lat: cepAbertoAddress.latitude,
        long: cepAbertoAddress.longitude,
      );
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error("CEP inválido");
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;

    this.address = address;

    if (await calculateDelivery(address.lat!, address.long!)) {
      dataUser!.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error("Endereço fora do raio de entrega");
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = 0;

    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc['lat'] as double;
    final longStore = doc['long'] as double;

    final base = doc['base'] as num;
    final km = doc['km'] as num;
    final maxKm = doc['maxKm'] as num;

    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    if (dis > maxKm) {
      return false;
    }
    deliveryPrice = base + dis * km;

    return true;
  }
}
