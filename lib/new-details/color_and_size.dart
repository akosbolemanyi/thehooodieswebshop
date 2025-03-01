import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../components/SAVE-hoodie_item_tile.dart';

class ColorAndSize extends StatefulWidget {
  const ColorAndSize({
    super.key,
    required this.hoodie,
    required this.onSizeChanged,
    required this.onStockChanged,
  });

  final HoodieItemTile hoodie;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onStockChanged;

  @override
  _ColorAndSizeState createState() => _ColorAndSizeState();
}

class _ColorAndSizeState extends State<ColorAndSize> {
  String selectedSize = "m";
  int stockQuantity = 0;

  @override
  void initState() {
    super.initState();
    fetchStockQuantity(selectedSize);
  }

  // Aszinkron funkció, amely visszatér a stockQuantity-val
  Future<int> fetchStockQuantity(String size) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.hoodie.itemName)
          .collection('sizes')
          .doc(size)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot['onStock'] ?? 0;
      }
    } catch (e) {
      print("Error fetching stock quantity: $e");
    }
    return 0; // Ha nem található adat, akkor 0-t adunk vissza
  }

  void onSizeSelected(String size) async {
    setState(() {
      selectedSize = size; // Frissíti a kiválasztott méretet
    });

    // Aszinkron hívás, hogy frissítse a stockQuantity-t
    int newStockQuantity = await fetchStockQuantity(size);
    setState(() {
      stockQuantity = newStockQuantity; // Frissíti a készlet értékét
    });

    widget.onSizeChanged(size); // Átadja a kiválasztott méretet
    widget.onStockChanged(stockQuantity); // Átadja az új stockQuantity-t
  }

  @override
  Widget build(BuildContext context) {
    print('-------------------------------------------------- ' + stockQuantity.toString());
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Méret",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: ["s", "m", "l", "xl"].map((size) =>
                    SizeOption(
                      size: size,
                      isSelected: selectedSize == size,
                      onTap: onSizeSelected,
                    )
                ).toList(),
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
                  stockQuantity > 5 ? Icons.check_circle :
                  (stockQuantity > 0 ? Icons.warning : Icons.cancel),
                  color: stockQuantity > 5 ? Colors.green :
                  (stockQuantity > 0 ? Colors.orange : Colors.red),
                ),
                const SizedBox(width: 8),
                Text(
                  stockQuantity > 5 ? "Raktáron" :
                  (stockQuantity > 0 ? "Már csak $stockQuantity db!" : "Elfogyott!"),
                  style: TextStyle(
                    color: stockQuantity > 5 ? Colors.green :
                    (stockQuantity > 0 ? Colors.orange : Colors.red),
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
        margin: const EdgeInsets.only(top: kDefaultPaddin / 4, right: kDefaultPaddin / 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kTextColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? kTextColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(
          size,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? kTextColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
