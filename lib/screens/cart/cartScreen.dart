import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plant_app/controller/controller.dart';
import 'package:get/get.dart';
import 'package:plant_app/screens/PaymentMethod/payment_method.dart';
import 'package:plant_app/widgets/empty_widget.dart';

final FoodController controller = Get.put(FoodController());
List<Map<String, dynamic>> getCartDetails() {
  return controller.cartFood.map((item) {
    return {
      'title': item.name,
      'amount': item.price,
      'image': item.imagePath,
      'quantity': item.quantity,
      'description': item.description,
      'height': item.height,
      'width': item.width,
      'length': item.size,
      'selectcategory': item.category,
    };
  }).toList();
}

void clearCart() {
  controller.cartFood.clear(); // Clears all items from the cart.
  // update(); // Notify listeners (if using GetX or similar).
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double _calculateTotal() {
    // Convert placeholderText to double
    final double subtotal =
        double.tryParse(controller.subtotalPrice.value.toString()) ?? 0.0;
    const double taxRate = 0.05; // 5% tax

    // Calculate total
    final double total = subtotal + (subtotal * taxRate);

    return total;
  }

  /// AppBar for the cart screen
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF33A248),
              Color(0xFFB2EA50),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
      title: const Text("Cart Screen"),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     const Text("Cart Screen"),

      //     IconButton(
      //       icon: const Icon(Icons.shopping_cart),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Navigation()),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  /// Bottom navigation bar showing cart subtotal and total
  Widget _buildBottomAppBar(BuildContext context) {
    // final height = MediaQuery.of(context).size.height * 0.30;
    return BottomAppBar(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF33A248), Color(0xFFB2EA50)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Column(
            children: [
              _buildRow('Number of Items', "${controller.cartFood.length}"),
              const SizedBox(height: 10),
              _buildRow('Subtotal', "${controller.subtotalPrice.value}"),
              const SizedBox(height: 10),
              _buildRow('Services Charges', "5%"), // Assuming no taxes for donations
              const Divider(thickness: 4.0, height: 30.0, color: Colors.black),
              _buildRow(
                'Total',
                "Rs. ${_calculateTotal()}",
                isBold: true,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    List<Map<String, dynamic>> cartDetails = getCartDetails();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethod(
                          placeholderText: "${controller.subtotalPrice.value}",
                          donationtitle:
                              cartDetails.map((e) => e['title']).join(', '),
                          amount:
                              cartDetails.map((e) => e['amount']).join(', '),
                          quantity:
                              cartDetails.map((e) => e['quantity']).join(', '),
                          headingcategory: cartDetails
                              .map((e) => e['headingcategory'])
                              .join(', '),
                          age: cartDetails.map((e) => e['age']).join(', '),
                          gender:
                              cartDetails.map((e) => e['gender']).join(', '),
                          selectcategory: cartDetails
                              .map((e) => e['selectcategory'])
                              .join(', '),
                        ),
                      ),
                    ).then((_) {
                      clearCart(); // Clear the cart after the navigation.
                    });
                    clearCart();
                  },
                  child: const Text(
                    "Checkout",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a row with a label and value for the bottom navigation
  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// Builds the list view for cart items
  Widget _buildCartListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      shrinkWrap: true,
      itemCount: controller.cartFood.length,
      itemBuilder: (_, index) {
        final item = controller.cartFood[index];
        return Dismissible(
          key: Key(item.name),
          onDismissed: (_) {
            controller.removeCartItemAtSpecificIndex(index);
            setState(() {
              controller.removeCartItemAtSpecificIndex(index);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Item removed from cart")),
            );
          },
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.only(left: 20),
              child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
            ),
          ),
          child: _buildCartItem(item),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
    );
  }

  /// Builds a single cart item widget
  Widget _buildCartItem(dynamic item) {
    return Container(
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildCartHeader(item.name),
          _buildCartDetails(item),
        ],
      ),
    );
  }

  /// Builds the cart item header
  Widget _buildCartHeader(String title) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF89D43F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: Text(title, style: const TextStyle(fontSize: 14)),
    );
  }

  /// Builds the details for a cart item
  Widget _buildCartDetails(dynamic item) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: _getImageProvider(item.imagePath),
              // image: NetworkImage("https://sadqahzakaat.com${item.image}"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Final Cost", style: TextStyle(fontSize: 14)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rs. ${item.price}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Text("${item.quantity}")
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  // if (item.isZakat) _buildDonationType("Zakat Donation"),
                  // if (item.isSadqah) _buildDonationType("Sadqah Donation"),
                ],
              ),
              // if (item.headingcategory.isNotEmpty &&
              //     item.selectcategory.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(item.headingcategory),
                      const SizedBox(width: 5),
                      Text(item.category),
                    ],
                  ),
                ),
              // if (item.gender.isNotEmpty && item.age.isNotEmpty)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(item.gender),
              //         const SizedBox(width: 5),
              //         Text(item.age),
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the donation type label
  Widget _buildDonationType(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: controller.cartFood.isNotEmpty
          ? _buildBottomAppBar(context)
          : const SizedBox(),
      body: EmptyWidget(
        title: "Empty cart",
        condition: controller.cartFood.isNotEmpty,
        child: SizedBox(
          height: height * 0.5,
          child: GetBuilder(
            builder: (FoodController controller) => _buildCartListView(),
          ),
        ),
      ),
    );
  }
}

/// Determines whether to use NetworkImage or AssetImage
ImageProvider _getImageProvider(String image) {
  // print("https://sadqahzakaat.com$image");
  if (image.startsWith('/data/') || image.startsWith('https')) {
    return NetworkImage('https://sadqahzakaat.com$image');
  } else {
    return AssetImage(image);
  }
}

//
