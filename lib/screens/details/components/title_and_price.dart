import 'package:flutter/material.dart';

import '../../../constants.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({
    Key? key,
    required this.title,
    required this.country,
    required this.price, required this.description,
  }) : super(key: key);

  final String title, country;
  final double price;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "$title\n",
                      style: TextStyle(
                    fontSize: 25,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                    // .copyWith(color: kTextColor, fontWeight: FontWeight.bold),
                    ),
                TextSpan(
                  text: country,
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          // Spacer(),
          Text("$description", style: Theme.of(context).textTheme.bodyMedium,
                maxLines: null, // 🔥 allow unlimited lines
  softWrap: true, // 🔥 wrap to next line
              ),
          Spacer(),
          Text("\$$price", style: Theme.of(context).textTheme.bodyMedium
              // .copyWith(color: kPrimaryColor),
              )
        ],
      ),
    );
  }
}
