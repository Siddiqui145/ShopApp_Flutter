import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteProductPage extends StatefulWidget {
  const DeleteProductPage({Key? key}) : super(key: key);

  @override
  _DeleteProductPageState createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  List<String> selectedProductIds = [];

  Stream<QuerySnapshot> _getProductsStream() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  Future<void> _deleteSelectedProducts() async {
    for (String productId in selectedProductIds) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected products deleted successfully')),
    );
    setState(() {
      selectedProductIds.clear();
    });
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
              "Are you sure you want to delete the selected products?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteSelectedProducts();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: selectedProductIds.isEmpty
                ? null
                : () {
                    _showDeleteConfirmationDialog();
                  },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getProductsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productId = product.id;
              final productData = product.data() as Map<String, dynamic>;

              return ListTile(
                leading: Checkbox(
                  value: selectedProductIds.contains(productId),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        selectedProductIds.add(productId);
                      } else {
                        selectedProductIds.remove(productId);
                      }
                    });
                  },
                ),
                title: Text(productData['company'] ?? 'Unknown'),
                subtitle: Text('Price: ${productData['price']}'),
                trailing: Image.network(productData['image'],
                    width: 50, height: 50, fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
