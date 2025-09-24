class Plant {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? headingCategory;
  final bool popular;
  final bool recommended;
  final bool heart;
  final double height;
  final double width;
  final String size;
  final List<PlantImage> images;

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.headingCategory,
    required this.popular,
    required this.recommended,
    required this.heart,
    required this.height,
    required this.width,
    required this.size,
    required this.images,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category'],
      headingCategory: json['heading_category'],
      popular: json['popular'],
      recommended: json['recommended'],
      heart: json['heart'],
      height: (json['height'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      size: json['size'],
      images: (json['images'] as List)
          .map((img) => PlantImage.fromJson(img))
          .toList(),
    );
  }
}

class PlantImage {
  final int id;
  final String image;
  final String? altText;

  PlantImage({
    required this.id,
    required this.image,
    this.altText,
  });

  factory PlantImage.fromJson(Map<String, dynamic> json) {
    return PlantImage(
      id: json['id'],
      image: json['image'],
      altText: json['alt_text'],
    );
  }
}
