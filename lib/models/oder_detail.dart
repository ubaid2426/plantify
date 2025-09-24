class OrderDetail {
  final int id;
  final int buyer;
  final int product;
  final int quantity;
  final String unitPrice;
  final String totalPrice;
  final String paymentStatus;
  final String createdAt;

  OrderDetail({
    required this.id,
    required this.buyer,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      buyer: json['buyer'],
      product: json['product'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      paymentStatus: json['payment_status'],
      createdAt: json['created_at'],
    );
  }
}
