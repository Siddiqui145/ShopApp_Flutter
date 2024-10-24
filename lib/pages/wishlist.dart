import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    final wishlistIds = Provider.of<WishListProvider>(context).wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text("WishList Page"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          if (wishlistIds.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'Your wishlist is empty',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where(FieldPath.documentId, whereIn: wishlistIds)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No products found in wishlist.'));
                  }

                  final wishlistItems = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      final wishlistItem =
                          wishlistItems[index].data() as Map<String, dynamic>;
                      final documentId = wishlistItems[index].id;

                      final image = wishlistItem['image'] as String? ??
                          'assets/default_image.png';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(image),
                          radius: 30,
                        ),
                        title: Text(
                          wishlistItem['company']?.toString() ??
                              'No Company Name',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          'Price: ${wishlistItem['price'] ?? 0}\nCategory: ${wishlistItem['category'] ?? 'Unknown'}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            Provider.of<WishListProvider>(context,
                                    listen: false)
                                .addProduct(
                                    documentId); // Pass the ID as a String
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
