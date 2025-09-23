class PlantModel {
  final int id;
  final String name;
  final String imagePath;
  final String category;
  final String description;
  double price;
  final double width;
  final double height;
  final String size;
  final bool isPopular;
  final bool isRecommended;
  final bool isFavorit;
  final double quantity;

  PlantModel({
    required this.id,
    required this.quantity,
    required this.width,
    required this.height,
    required this.size,
    required this.isPopular,
    required this.isRecommended,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.price,
    required this.isFavorit,
  });
}
