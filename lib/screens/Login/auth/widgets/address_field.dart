
import 'package:flutter/material.dart';
import 'package:plant_app/screens/Login/components/colors.dart';
// import 'package:zakat_app/Screens/Login/components/colors.dart';

class AddressField extends StatelessWidget {
  final TextEditingController address;
  const AddressField({super.key,required this.address});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      child: TextFormField(
        validator: (value) {
          if (value!.length < 5) {
            return "invalid address";
          } else {
            return null;
          }
        },
        controller: address,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.location_on_sharp,
            color: MyColors().maincolor,
          ),
          label: Text(
            'Address in details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors().maincolor,
            ),
          ),
        ),
      ),
    );
  }
}
