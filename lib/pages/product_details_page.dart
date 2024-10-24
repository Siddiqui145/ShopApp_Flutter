import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  dynamic selectedOption;

  void onTap() {
    if (selectedOption != null) {
      Provider.of<CartProvider>(context, listen: false).addProduct(
        {
          'id': widget.product['id'],
          'title': widget.product['title'],
          'price': widget.product['price'],
          'company': widget.product['company'],
          'option': selectedOption,
          'image': widget.product['image'],
          'category': widget.product['category'],
          'documentId': widget.product['documentId'],
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCategory = widget.product['category'] as String;
    List<dynamic> availableOptions = [];
    String optionLabel = 'Options';

    if (productCategory == 'Shoes') {
      availableOptions = widget.product['sizes'] ?? [];
      optionLabel = 'Sizes';
    } else if (productCategory == 'Clothes') {
      availableOptions = widget.product['length'] ?? [];
      optionLabel = 'Available Sizes';
    } else if (productCategory == 'Perfumes') {
      availableOptions = widget.product['quantities'] ?? [];
      optionLabel = 'Quantities';
    } else if (productCategory == 'Glasses') {
      availableOptions = widget.product['types'] ?? [];
      optionLabel = 'Types';
    } else if (productCategory == 'Watches') {
      availableOptions = widget.product['style'] ?? [];
      optionLabel = 'Style';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Product details")),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              widget.product['company'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              width: double.infinity,
              child: Image.network(
                widget.product['image'] as String,
              ),
            ),
          ),
          const Spacer(flex: 2),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 219, 191, 167),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '₹${widget.product['price']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                if (availableOptions.isNotEmpty) ...[
                  Text(
                    optionLabel,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableOptions.length,
                      itemBuilder: (context, index) {
                        final option = availableOptions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = option;
                              });
                            },
                            child: Chip(
                              label: Text(option.toString()),
                              backgroundColor: selectedOption == option
                                  ? Colors.black
                                  : null,
                              labelStyle: TextStyle(
                                color: selectedOption == option
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else
                  const Text('No options available'),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(150, 50),
                    ),
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
