import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import '../../../../models/product.model.dart';
import '../../../../providers/cart.provider.dart';

class ProductSizeSelector extends StatefulWidget {
  const ProductSizeSelector({
    super.key,
    required this.product,
    required this.onSizeChanged,
    required this.onStockChanged,
  });

  final ProductModel product;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onStockChanged;

  @override
  _ProductSizeSelectorState createState() => _ProductSizeSelectorState();
}

class _ProductSizeSelectorState extends State<ProductSizeSelector> {
  String selectedSize = "M";
  int stockQuantity = 0;

  @override
  void initState() {
    super.initState();
    fetchStockQuantity(selectedSize);
  }

  Future<int> fetchStockQuantity(String size) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .collection('sizes')
          .doc(size)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot['inStock'] ?? 0;
      }
    } catch (e) {
      print("Error fetching stock quantity: $e");
    }
    return 0;
  }

  void onSizeSelected(String size) async {
    setState(() {
      selectedSize = size;
    });
    int newStockQuantity = await fetchStockQuantity(size);

    setState(() {
      stockQuantity = newStockQuantity;
    });

    widget.onSizeChanged(size);
    widget.onStockChanged(stockQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      int cartQuantity = 0;
      var existingItem = cartProvider.cartItems.firstWhere(
        (item) =>
            item['id'] == widget.product.id && item['size'] == selectedSize,
        orElse: () => {},
      );
      if (existingItem.isNotEmpty) {
        cartQuantity = existingItem['quantity'] ?? 0;
      }

      final int activeStock = stockQuantity - cartQuantity;
      return Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const LocaleText(
                  "size",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ["S", "M", "L", "XL"]
                      .map((size) => SizeOption(
                            size: size,
                            isSelected: selectedSize == size,
                            onTap: onSizeSelected,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 40),
              child: Row(
                children: [
                  Icon(
                    activeStock > 5
                        ? Icons.check_circle
                        : (activeStock > 0 ? Icons.warning : Icons.cancel),
                    color: activeStock > 5
                        ? Colors.green
                        : (activeStock > 0 ? Colors.orange : Colors.red),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activeStock > 5
                        ? Locales.string(context, 'in_stock')
                        : (activeStock > 0
                            ? "$activeStock ${Locales.string(context, 'quantity')}"
                            : Locales.string(context, 'out_of_stock')),
                    style: TextStyle(
                      color: activeStock > 5
                          ? Colors.green
                          : (activeStock > 0 ? Colors.orange : Colors.red),
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class SizeOption extends StatelessWidget {
  const SizeOption({
    super.key,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  final String size;
  final bool isSelected;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(size),
      child: Container(
        margin: const EdgeInsets.only(top: 20.0 / 4, right: 20.0 / 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
          color:
              isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(
          size,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}
