
# 🛍️ Flutter Shopping App

A complete e-commerce mobile application built with **Flutter**. This app allows users to browse products, add them to their cart, save items to a wishlist, and proceed to checkout. It uses **Firebase Firestore** for real-time data storage and retrieval. Additionally, the app provides **admin** and **customer** roles for a differentiated experience.

## 📱 Features

- **Browse Products:** View a list of products fetched from Firestore.
- **Add to Cart:** Select products, choose options (size, color, etc.), and add them to the cart.
- **Wishlist:** Save favorite products for later in the wishlist.
- **Cart Management:** Update or remove products from the cart and view the total price.
- **Checkout:** Proceed to address input and payment after finalizing the cart.
- **Admin Role:** Admins can add, edit, or remove products, manage orders, and view customer lists.
- **Customer Role:** Customers can browse products, add them to the cart or wishlist, and proceed to checkout.
- **Firebase Integration:** Products, cart, and wishlist are synchronized with Firestore.
- **Network Image Loading with Error Handling:** Products are displayed with images fetched from a URL, and if the image fails, a fallback image or a placeholder is shown.

## Demo


### SignUp & Login, along with Reset
https://github.com/user-attachments/assets/b99017bb-2ff0-4901-a1a2-9689dbea702e

### Products, Cart, Ordering, Payments
https://github.com/user-attachments/assets/f9d4b91f-7308-4f11-bde3-40fa6584043c

### WishList Features
https://github.com/user-attachments/assets/c24b66a2-bf4a-4c03-b31b-6dd04267031c

### SearchBar and Extra Features
https://github.com/user-attachments/assets/120ffac0-10c6-40ea-bb49-16479fd208f3

### ADMIN Login, to Dynamically add and remove products
https://github.com/user-attachments/assets/e31c6dbe-c653-4565-bd0f-10a105924ae6







## 🎯 Use Cases

1. **Customer Experience:**
   - Users can browse through a catalog of products.
   - Add selected products to the cart or wishlist.
   - Remove items from the cart or wishlist and update the total price in real-time.
   - View detailed product information including price, category, and available options.
   - Proceed to checkout and input delivery details.

2. **Admin Experience:**
   - Admins can manage the product catalog by adding, updating, or removing products.
   - View and manage customer orders.
   - Monitor product inventory and update stock.

3. **Cart and Checkout:**
   - Customers can manage their cart (add, remove, or modify items).
   - Proceed to checkout after confirming their cart and total price.
   - Input address information and complete the purchase (further integration with payment gateways can be added).

4. **Wishlist:**
   - Users can add items to their wishlist and revisit them later for purchasing decisions.

## 🚀 Getting Started

Follow these steps to set up the project locally.

### Prerequisites

- **Flutter SDK**: Ensure you have Flutter installed on your machine. You can download it from [Flutter's official site](https://flutter.dev/docs/get-started/install).
- **Firebase Project**: Set up a Firebase project and enable Firestore. Follow the [Firebase setup guide](https://firebase.flutter.dev/docs/overview) to integrate Firebase with Flutter.

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Siddiqui145/ShopApp_Flutter.git
   cd ShopApp_Flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Download the `google-services.json` file from your Firebase Console and place it in the `android/app/` directory.
   - Similarly, for iOS, download the `GoogleService-Info.plist` file and add it to the `ios/Runner` directory.
   - Configure Firebase according to [this guide](https://firebase.flutter.dev/docs/overview).

4. **Run the project**:
   ```bash
   flutter run
   ```

### Project Structure

```bash
lib/
├── main.dart                     # Entry point of the application
├── pages/
│   ├── cart_page.dart             # Cart management page
│   ├── form_page.dart             # Address input and checkout page
│   ├── wishlist_page.dart         # Wishlist page
│   ├── admin_dashboard.dart       # Admin dashboard for managing products
├── providers/
│   ├── cart_provider.dart         # Cart management provider (state management)
│   ├── wishlist_provider.dart     # Wishlist management provider
├── widgets/
│   ├── product_tile.dart          # Custom widget for displaying product details
├── services/
│   ├── firebase_service.dart      # Firebase-related functions for data fetching
```

## 📁 Firebase Configuration

The project uses **Firebase Firestore** to store and retrieve product information, cart data, and wishlist data. Ensure you have:

- Enabled Firestore in your Firebase console.
- Added the correct security rules for Firestore.

Example Firestore structure:

```
Firestore Root
├── products (collection)
│   ├── {productDocumentId} (document)
│   │   ├── image: String (URL of the product image)
│   │   ├── company: String (Product company)
│   │   ├── price: Number (Product price)
│   │   ├── category: String (Product category)
│   │   ├── description: String (Product description)
│   │   ├── options: Array (Available options, e.g., size, color)
├── users (collection)
│   ├── {userId} (document)
│   │   ├── role: String (admin or customer)
```

## 🛠️ Technologies Used

- **Flutter**: A cross-platform mobile app development framework.
- **Provider**: For state management.
- **Firebase Firestore**: For cloud-based NoSQL database.
- **Firebase Authentication** (Optional): Can be added for user login/signup and role-based access control.
- **Image.network**: For loading product images with network error handling.

## 📖 Usage

- **Customer Role**:
  - Customers can browse products, add items to the cart or wishlist, and proceed to checkout.
  - Customers will see only the shopping-related functionalities like cart management and wishlist.
  
- **Admin Role**:
  - Admins have access to special features like adding or removing products, managing inventory, and viewing customer orders.
  - Admin-specific pages are available, like product management and order management.

- **Product Display**: Products are displayed with their images, company names, prices, and available options.
- **Cart Functionality**: Items can be added, removed, and viewed in a cart with the total price dynamically calculated.
- **Wishlist**: Users can add items to their wishlist and view them later.
- **Checkout**: After finalizing the cart, users can proceed to input their address for delivery.

## 🚧 Future Enhancements

- **Payment Gateway Integration**: Add support for online payments (Stripe, Razorpay, etc.).
- **User Authentication**: Firebase Authentication for user login, registration, and personalized carts/wishlists.
- **Push Notifications**: Notify users about product offers, abandoned carts, etc.
- **Product Reviews**: Allow users to rate and review products.

## 🤝 Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the project.
2. Create a feature branch:
   ```bash
   git checkout -b feature/new-feature
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/new-feature
   ```
5. Open a pull request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙌 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Provider Package](https://pub.dev/packages/provider)

---

Feel free to use, modify, and contribute to this project. If you encounter any issues, feel free to open an issue or submit a pull request.
