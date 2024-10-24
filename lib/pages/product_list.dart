import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/product_details_page.dart';
import 'package:shop_app/providers/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../admin/SideBar.dart';

class ProductList extends StatefulWidget {
  ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    'Shoes',
    'Watches',
    'Clothes',
    'Perfumes',
    'Glasses'
  ];
  late String selectedFilter;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  List<DocumentSnapshot> getFilteredProducts(List<DocumentSnapshot> products) {
    return products.where((doc) {
      final product = doc.data() as Map<String, dynamic>;
      return (product['category'] == selectedFilter ||
              selectedFilter == 'All') &&
          (product['company']?.toString().toLowerCase() ?? '')
              .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email ?? "No user is Signed in";
    final wishlistProvider = Provider.of<WishListProvider>(context);

    final InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    );

    return Scaffold(
      drawer: SideBar(email, context),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("75BRANDSTORE", style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ],
            ),
            Image.asset("assets/images/brand/logo.jpg"),
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        backgroundColor: selectedFilter == filter
                            ? const Color.fromARGB(255, 0, 8, 15)
                            : const Color.fromRGBO(245, 247, 249, 1),
                        label: Text(filter),
                        labelStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No Data Here'));
                  }

                  final products = snapshot.data!.docs;
                  final filteredProducts = getFilteredProducts(products);

                  return filteredProducts.isNotEmpty
                      ? GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final productDoc = filteredProducts[index];
                            final product =
                                productDoc.data() as Map<String, dynamic>;
                            final price = product['price'];
                            final image = product['image'];
                            final company = product['company'];
                            final documentId = productDoc.id;

                            final isInWishlist =
                                wishlistProvider.isInWishlist(documentId);

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailsPage(
                                          product: product);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: index.isEven
                                      ? const Color.fromARGB(168, 210, 182,
                                          182) // Light Gray for even items
                                      : const Color.fromARGB(255, 0, 24,
                                          13), // Soft Mint Green for odd items
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                          child: Image.network(
                                            image,
                                            //   fit: BoxFit.cover,
                                            //   width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      company,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '₹$price',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isInWishlist
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isInWishlist
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        if (isInWishlist) {
                                          wishlistProvider
                                              .removeProduct(documentId);
                                        } else {
                                          wishlistProvider
                                              .addProduct(documentId);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No products available',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
