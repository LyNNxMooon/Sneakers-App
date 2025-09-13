import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/colors.dart';

class CartDetailWidget extends StatelessWidget {
  const CartDetailWidget(
      {super.key, required this.totalAmount, required this.grandTotal});

  final double totalAmount;
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 105,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(12), // Slightly rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Soft shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                "$totalAmount Ks",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                "$grandTotal Ks",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Your action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16),
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
                child: Text("Order", style: TextStyle(fontSize: 12),),
              )
            ],
          )
        ],
      ),
    );
  }
}
