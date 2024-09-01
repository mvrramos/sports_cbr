class ItemSize {
  ItemSize({this.name, this.price, this.stock});

  ItemSize.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    price = map['price'];
    stock = map['stock'];
  }

  String? name;
  num? price;
  int? stock;

  bool get hasStock => stock! > 0;

  ItemSize clone() {
    return ItemSize(name: name, price: price, stock: stock);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock
    };
  }

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock $stock}';
  }
}
