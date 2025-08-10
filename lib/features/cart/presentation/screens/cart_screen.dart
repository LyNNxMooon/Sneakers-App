import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/constants/txt_styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Gap(30),
        Center(child: Text("C a r t", style: ktitleStyle)),
      ],
    );
  }
}
