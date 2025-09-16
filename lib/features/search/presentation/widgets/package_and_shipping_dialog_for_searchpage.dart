import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneakers_app/entities/vos/sneaker_vo.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_bloc.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';
import 'package:sneakers_app/utils/navigation_extension.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/enums.dart';
import '../../../cart/presentation/BLoC/cart_events.dart';

class PackageAndShippingDialogForSearchPage extends StatefulWidget {
  const PackageAndShippingDialogForSearchPage(
      {super.key, required this.sneaker});

  final SneakerVO sneaker;

  @override
  State<PackageAndShippingDialogForSearchPage> createState() =>
      _PackageAndShippingDialogForSearchPageState();
}

class _PackageAndShippingDialogForSearchPageState
    extends State<PackageAndShippingDialogForSearchPage> {
  String? _selectedPackaging;
  String? _selectedShipping;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kThirdColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Select Packaging & Shipping",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: kFourthColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First group: Packaging
          _buildRadioGroup(
            title: "Packaging Options",
            options: ["Plastic Wrapper", "Wooden Wrapper", "Fragile Package"],
            groupValue: _selectedPackaging,
            onChanged: (value) {
              setState(() {
                _selectedPackaging = value;
                _selectedShipping = null; // reset shipping if packaging changes
              });
            },
            enabled: true,
          ),
          const SizedBox(height: 20),

          // Second group: Shipping
          _buildRadioGroup(
            title: "Shipping Options",
            options: ["Shipment", "Land Cargo", "Air Cargo"],
            groupValue: _selectedShipping,
            onChanged: (value) {
              setState(() {
                _selectedShipping = value;
              });
            },
            enabled:
                _selectedPackaging != null, // enabled only if packaging chosen
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.navigateBack(),
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        BlocConsumer<CartBloc, CartStates>(
          builder: (context, state) {
            if (state is CartLoading) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: CupertinoActivityIndicator(),
              );
            }

            return TextButton(
              onPressed: () {
                context.read<CartBloc>().add(AddToCartEvent(
                    sneaker: widget.sneaker,
                    qty: 1,
                    package: _selectedPackaging != null,
                    shipping: _selectedShipping != null,
                    packageType: _selectedPackaging ?? "",
                    shippingType: _selectedShipping ?? ""));

                context.read<CartBloc>().add(LoadCart(cartType: CartType.cart, context: context));
              },
              child: Text("OK", style: TextStyle(color: Colors.white)),
            );
          },
          listener: (context, state) {
            if (state is CartError) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: state.message,
                ),
              );
            }

            if (state is AddedToCart) {
              context.navigateBack();
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(
                  maxLines: 5,
                  message: state.message,
                ),
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildRadioGroup({
    required String title,
    required List<String> options,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(color: kFourthColor, fontWeight: FontWeight.bold)),
        ...options.map((option) {
          return RadioListTile<String>(
            value: option,
            groupValue: groupValue,
            onChanged: enabled ? onChanged : null,
            title: Text(
              option,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.grey,
              ),
            ),
            activeColor: Colors.white,
          );
        }),
      ],
    );
  }
}
