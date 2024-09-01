class SectionItem {
  SectionItem({this.product, this.image});

  dynamic image;
  String? product;

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] ?? '';
    product = map['product'] ?? '';
  }
  @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }

  SectionItem clone() {
    return SectionItem(
      image: image,
      product: product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'product': product,
    };
  }
}
