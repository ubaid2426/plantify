
import 'package:flutter/material.dart';
import 'package:plant_app/screens/Login/components/colors.dart';

class EmailField extends StatelessWidget {
  final TextEditingController email;
  const EmailField({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.length < 13) {
            return "invalid gmail";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          
          suffixIcon: Icon(
            Icons.email,
            color: MyColors().maincolor,
          ),
          label: Text(
            'Gmail',
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
