import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/home_page.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({super.key});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<String?> uploadFile() async {
    if (pickedFile == null) return null;

    try {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);

      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  List<String> selectedSizes = [];
  String? selectedCategory;
  List<String> selectedAttributes = [];

  List<String> availableCategories = [
    "Shoes",
    "Watches",
    "Clothes",
    "Perfumes",
    "Glasses",
  ];

  final Map<String, List<String>> categoryAttributes = {
    'Shoes': ['6', '7', '8', '9', '10', '11', '12'],
    'Watches': ['Metal', 'Steel', 'Leather'],
    'Clothes': ['M', 'L', 'XL', 'XXL'],
    'Perfumes': ['30ml', '50ml', '100ml'],
    'Glasses': ['Polarized', 'Non-Polarized', 'Power', 'Sun-Glasses'],
  };

  Future<void> _showAttributeSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  'Select ${selectedCategory == 'Shoes' || selectedCategory == 'Clothes' ? (selectedCategory == 'Clothes' ? 'Length' : 'Sizes') : 'Attributes'}'),
              content: SingleChildScrollView(
                child: Column(
                  children:
                      categoryAttributes[selectedCategory]!.map((attribute) {
                    return CheckboxListTile(
                      title: Text(attribute),
                      value: selectedAttributes.contains(attribute),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!selectedAttributes.contains(attribute)) {
                              selectedAttributes.add(attribute);
                            }
                          } else {
                            selectedAttributes.remove(attribute);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final imageUrl = await uploadFile();
        if (imageUrl == null) return;

        final int price = int.parse(priceController.text.trim());

        Map<String, dynamic> productData = {
          'price': price,
          'company': companyController.text.trim(),
          'image': imageUrl,
          'category': selectedCategory ?? 'Uncategorized',
        };

        if (selectedCategory == 'Shoes') {
          productData['sizes'] = selectedAttributes;
        } else if (selectedCategory == 'Clothes') {
          productData['length'] = selectedAttributes;
        } else if (selectedCategory == 'Perfumes') {
          productData['quantities'] = selectedAttributes;
        } else if (selectedCategory == 'Glasses') {
          productData['types'] = selectedAttributes;
        } else if (selectedCategory == 'Watches') {
          productData['style'] = selectedAttributes;
        }

        await FirebaseFirestore.instance
            .collection('products')
            .add(productData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product uploaded successfully!'),
          ),
        );

        priceController.clear();
        companyController.clear();
        selectedAttributes.clear();
        selectedCategory = null;
        pickedFile = null;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload New Product"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Category dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Select Category"),
                value: selectedCategory,
                items: availableCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedAttributes.clear();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Price input
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: selectedCategory != null
                    ? _showAttributeSelectionDialog
                    : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    selectedAttributes.isEmpty
                        ? 'Select Attributes'
                        : '${selectedCategory == 'Shoes' || selectedCategory == 'Clothes' ? 'Sizes' : 'Attributes'}: [${selectedAttributes.join(', ')}]',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (pickedFile != null)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: selectFile,
                child: const Text('Select Image File'),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: uploadProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    companyController.dispose();
    super.dispose();
  }
}
