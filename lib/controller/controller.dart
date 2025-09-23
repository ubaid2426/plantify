import 'package:get/get.dart';
import 'package:plant_app/core/app_extension.dart';
import 'package:plant_app/models/plant_model.dart';

class FoodController extends GetxController {
  RxInt currentBottomNavItemIndex = 0.obs;
  RxList<PlantModel> cartFood = <PlantModel>[].obs;
  RxDouble totalPrice = 0.0.obs;
  RxDouble subtotalPrice = 0.0.obs;

  // Switch between bottom navigation items
  void switchBetweenBottomNavigationItems(int currentIndex) {
    currentBottomNavItemIndex.value = currentIndex;
  }

  // Function to calculate total and subtotal prices
  void calculateTotalPrice() {
    totalPrice.value = 0; // Reset total price
    for (var element in cartFood) {
      totalPrice.value += element.price!; // Ensure element has a 'price' attribute
    }

    subtotalPrice.value = totalPrice.value; // Set subtotal equal to total
  }

  // Add a donation to the cart
  void addToCart(PlantModel donation) {
    // Check if the donation already exists
    final existingDonation = cartFood.firstWhereOrNull((item) => item.id == donation.id);
    if (existingDonation != null) {
      // Update the price if it already exists
      // existingDonation.price += donation.price!;
      existingDonation.price = donation.price! + existingDonation.price!;
    } else {
      cartFood.add(donation); // Add the donation model
    }

    cartFood.assignAll(cartFood.distinctBy((item) => item.id)); // Remove duplicates
    calculateTotalPrice(); // Recalculate the total price
  }


  int donationAmount = 0;

  void increaseDonation() {
    donationAmount++;
    update(); // Update the UI
  }

  void decreaseDonation() {
    if (donationAmount > 0) {
      donationAmount--;
      update(); // Update the UI
    }
  }



  // Remove an item from the cart by index
  void removeCartItemAtSpecificIndex(int index) {
    cartFood.removeAt(index); // Remove item at specific index
    calculateTotalPrice(); // Recalculate the total price
    update(); // Update the UI
  }
}
















